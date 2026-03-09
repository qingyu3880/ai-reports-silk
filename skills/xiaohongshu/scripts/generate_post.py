#!/usr/bin/env python3
"""Generate Xiaohongshu style content"""
import argparse
import random

templates = {
    'travel': [
        "🌟 发现了宝藏地方！{place}真的太美了\n\n📍 {location}\n\n{highlight}\n\n💡 Tips:\n{tips}\n\n#旅行 #打卡 #{tag}",
    ],
    'food': [
        "🍜 北京必吃！这家{food}绝了\n\n📍 {location}\n\n{highlight}\n\n💰 人均: {price}\n\n#美食 #探店 #{tag}",
    ],
    'lifestyle': [
        "✨ {topic} | 提升幸福感的{count}件小事\n\n{items}\n\n💭 {thought}\n\n#生活方式 #{tag}",
    ]
}

def generate_post(topic, style='lifestyle'):
    if style not in templates:
        style = 'lifestyle'
    
    template = random.choice(templates[style])
    
    # Fill template based on style
    if style == 'travel':
        return template.format(
            place='大理古城',
            location='云南大理',
            highlight='清晨的古城特别安静，石板路、老房子，仿佛穿越回十年前。',
            tips='1. 早上8点前到，避开人流\n2. 记得带相机，每个角落都是风景',
            tag='大理'
        )
    elif style == 'food':
        return template.format(
            food='老北京炸酱面',
            location='东城区xx胡同',
            highlight='面条劲道，炸酱香浓，配菜新鲜。老板做了30年，味道正宗！',
            price='35元',
            tag='北京美食'
        )
    else:
        return template.format(
            topic='周末独处时光',
            count='5',
            items='1. 泡一杯好茶🍵\n2. 读一本好书📖\n3. 听喜欢的音乐🎵\n4. 整理房间🧹\n5. 写日记✍️',
            thought='独处不是孤独，而是与自己对话的最好时光。',
            tag='独处时光'
        )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--topic', default='lifestyle')
    parser.add_argument('--style', default='lifestyle', choices=['travel', 'food', 'lifestyle'])
    args = parser.parse_args()
    
    post = generate_post(args.topic, args.style)
    print(post)
