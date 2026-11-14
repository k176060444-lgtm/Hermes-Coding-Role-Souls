import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const roles=JSON.parse(fs.readFileSync(path.join(root,'roles.json'),'utf8'));
const names=['planner','worker','spec_reviewer','quality_reviewer','tester_gate_a','worker_remediation','tester_gate_b','arbitrator','pro_audit'];
assert.deepEqual(Object.keys(roles.roles).sort(),names.sort());
for(const name of names){
 const r=roles.roles[name];
 assert.equal(r.soul_file,'souls/'+name+'.md');
 const soul=fs.readFileSync(path.join(root,r.soul_file),'utf8');
 assert(soul.trim().length>100);
 assert(soul.includes('Controller 机器回执'));
 assert(soul.includes('"verdict"'));
 assert.match(soul,/Permission-Intent: (read_only|workspace_write|test_files_only)/);
 assert.equal(r.soul_version,soul.match(/Soul-Version:\s*(\S+)/)[1]);
 assert.equal(r.soul_sha256,createHash('sha256').update(soul).digest('hex'));
}
const sums=new Map(fs.readFileSync(path.join(root,'SHA256SUMS.txt'),'utf8').trim().split(/\r?\n/).map(line=>{
 const m=line.match(/^([a-f0-9]{64})  (.+)$/);
 assert(m,line);
 return [m[2],m[1]];
}));
for(const [file,hash] of sums){
 assert.equal(createHash('sha256').update(fs.readFileSync(path.join(root,file))).digest('hex'),hash,file);
}
assert(!fs.readFileSync(path.join(root,'souls/arbitrator.md'),'utf8').includes('无争议也不得跳过'));
console.log('SOUL_SOURCE_STATIC_PASS: nine roles, SHA manifest, final JSON contract');
