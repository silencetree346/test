import requests
import json

BASE_URL = "http://localhost:8000"

def test_api():
    print("========================================")
    print("  API 接口测试")
    print("========================================\n")
    
    print("1. 测试根路径...")
    try:
        response = requests.get(f"{BASE_URL}/")
        print(f"   状态码: {response.status_code}")
        print(f"   响应: {response.json()}\n")
    except Exception as e:
        print(f"   ❌ 错误: {e}\n")
    
    print("2. 获取最新新闻...")
    try:
        response = requests.get(f"{BASE_URL}/api/news")
        print(f"   状态码: {response.status_code}")
        news = response.json()
        print(f"   新闻数量: {len(news)}")
        if news:
            print(f"   第一条: {news[0]['title']}\n")
    except Exception as e:
        print(f"   ❌ 错误: {e}\n")
    
    print("3. 生成报告...")
    try:
        response = requests.post(f"{BASE_URL}/api/reports/generate")
        print(f"   状态码: {response.status_code}")
        report = response.json()
        print(f"   报告日期: {report['date']}")
        print(f"   新闻数量: {len(report['news_items'])}")
        print(f"   建议数量: {len(report['recommendations'])}\n")
    except Exception as e:
        print(f"   ❌ 错误: {e}\n")
    
    print("4. 获取最新报告...")
    try:
        response = requests.get(f"{BASE_URL}/api/reports/latest")
        print(f"   状态码: {response.status_code}")
        report = response.json()
        print(f"   报告日期: {report['date']}\n")
    except Exception as e:
        print(f"   ❌ 错误: {e}\n")
    
    print("5. 获取所有报告...")
    try:
        response = requests.get(f"{BASE_URL}/api/reports")
        print(f"   状态码: {response.status_code}")
        reports = response.json()
        print(f"   报告总数: {len(reports)}\n")
    except Exception as e:
        print(f"   ❌ 错误: {e}\n")
    
    print("========================================")
    print("  测试完成")
    print("========================================")

if __name__ == "__main__":
    print("\n请确保服务已启动 (./start.sh)\n")
    input("按回车键开始测试...")
    test_api()




