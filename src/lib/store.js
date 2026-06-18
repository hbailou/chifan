import { supabase, hasSupabase } from './supabase';
const seed={people:[{id:'p1',name:'Hassan',team:'PM',phone:'',tsmc_phone_full:'',tsmc_phone_short:'',email:'',active:true},{id:'p2',name:'Person in Charge',team:'Site Office',phone:'',tsmc_phone_full:'',tsmc_phone_short:'',email:'',active:true}],restaurants:[{id:'r1',name:'Demo Bento',phone1:'02-0000-0000',phone2:'',address:'Taiwan',note:'',active:true}],menu_categories:[{id:'c1',restaurant_id:'r1',name:'Rice',sort_order:1},{id:'c2',restaurant_id:'r1',name:'Noodles',sort_order:2}],meals:[{id:'m1',restaurant_id:'r1',category_id:'c1',name:'Chicken Rice',price:100,active:true},{id:'m2',restaurant_id:'r1',category_id:'c1',name:'Beef Rice',price:120,active:true},{id:'m3',restaurant_id:'r1',category_id:'c2',name:'Beef Dry Noodle',price:120,active:true}],daily_orders:[],order_items:[]};
function local(){return JSON.parse(localStorage.getItem('chifan-v2')||JSON.stringify(seed))}
function save(d){localStorage.setItem('chifan-v2',JSON.stringify(d))}
const uid=()=>crypto.randomUUID?.()||Math.random().toString(36).slice(2);
export async function list(table){
  if(hasSupabase){
    const sortColumn = table === 'order_items' ? 'updated_at' : 'created_at';
    const {data,error}=await supabase.from(table).select('*').order(sortColumn,{ascending:true});
    if(error){ console.error('Chi-Fan Supabase list error', table, error); return [] }
    return data||[]
  }
  return local()[table]||[]
}
export async function insert(table,row){if(hasSupabase){const {data,error}=await supabase.from(table).insert(row).select().single(); if(error) throw error; return data} const d=local(); const newRow={id:uid(),created_at:new Date().toISOString(),...row}; d[table]=[...(d[table]||[]),newRow]; save(d); return newRow}
export async function update(table,id,patch){if(hasSupabase){const {data,error}=await supabase.from(table).update(patch).eq('id',id).select().single(); if(error) throw error; return data} const d=local(); d[table]=(d[table]||[]).map(x=>x.id===id?{...x,...patch}:x); save(d); return d[table].find(x=>x.id===id)}
export async function remove(table,id){if(hasSupabase){const {error}=await supabase.from(table).delete().eq('id',id); if(error) throw error; return} const d=local(); d[table]=(d[table]||[]).filter(x=>x.id!==id); save(d)}
export async function getTodayOrder(date,restaurant_id){let orders=await list('daily_orders'); let o=orders.find(x=>x.order_date===date); if(o)return o; return insert('daily_orders',{order_date:date,restaurant_id,status:'open'})}
export async function upsertOrderItem(item){if(hasSupabase){const {data,error}=await supabase.from('order_items').upsert(item,{onConflict:'daily_order_id,person_id'}).select().single(); if(error) throw error; return data} const d=local(); const ix=d.order_items.findIndex(x=>x.daily_order_id===item.daily_order_id&&x.person_id===item.person_id); if(ix>=0)d.order_items[ix]={...d.order_items[ix],...item,updated_at:new Date().toISOString()}; else d.order_items.push({id:uid(),...item,updated_at:new Date().toISOString()}); save(d)}

export async function deleteNoOrderItems(orderId){if(hasSupabase){const {error}=await supabase.from('order_items').delete().eq('daily_order_id',orderId).eq('status','no_order'); if(error) throw error; return} const d=local(); d.order_items=(d.order_items||[]).filter(x=>!(x.daily_order_id===orderId&&x.status==='no_order')); save(d)}
