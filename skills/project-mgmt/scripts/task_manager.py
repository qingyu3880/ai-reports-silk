#!/usr/bin/env python3
"""Simple task manager"""
import json
import os
import argparse
from datetime import datetime

DB_FILE = os.path.expanduser('~/.project_tasks.json')

def load_tasks():
    if os.path.exists(DB_FILE):
        with open(DB_FILE, 'r') as f:
            return json.load(f)
    return {'tasks': [], 'next_id': 1}

def save_tasks(data):
    with open(DB_FILE, 'w') as f:
        json.dump(data, f, indent=2)

def add_task(title, priority='medium', project='default'):
    data = load_tasks()
    task = {
        'id': data['next_id'],
        'title': title,
        'priority': priority,
        'status': 'todo',
        'project': project,
        'created': datetime.now().isoformat(),
        'updated': datetime.now().isoformat()
    }
    data['tasks'].append(task)
    data['next_id'] += 1
    save_tasks(data)
    print(f"Task added: #{task['id']} - {title}")
    return task['id']

def list_tasks(status=None, project=None):
    data = load_tasks()
    tasks = data['tasks']
    
    if status:
        tasks = [t for t in tasks if t['status'] == status]
    if project:
        tasks = [t for t in tasks if t['project'] == project]
    
    if not tasks:
        print("No tasks found.")
        return
    
    print(f"{'ID':<5} {'Status':<10} {'Priority':<10} {'Title'}")
    print("-" * 60)
    for t in tasks:
        print(f"{t['id']:<5} {t['status']:<10} {t['priority']:<10} {t['title']}")

def update_task(task_id, status=None, priority=None):
    data = load_tasks()
    for t in data['tasks']:
        if t['id'] == int(task_id):
            if status:
                t['status'] = status
            if priority:
                t['priority'] = priority
            t['updated'] = datetime.now().isoformat()
            save_tasks(data)
            print(f"Task #{task_id} updated")
            return
    print(f"Task #{task_id} not found")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest='command')
    
    add_p = subparsers.add_parser('add')
    add_p.add_argument('--title', required=True)
    add_p.add_argument('--priority', default='medium')
    add_p.add_argument('--project', default='default')
    
    list_p = subparsers.add_parser('list')
    list_p.add_argument('--status')
    list_p.add_argument('--project')
    
    update_p = subparsers.add_parser('update')
    update_p.add_argument('--id', required=True, type=int)
    update_p.add_argument('--status')
    update_p.add_argument('--priority')
    
    args = parser.parse_args()
    
    if args.command == 'add':
        add_task(args.title, args.priority, args.project)
    elif args.command == 'list':
        list_tasks(args.status, args.project)
    elif args.command == 'update':
        update_task(args.id, args.status, args.priority)
    else:
        parser.print_help()
