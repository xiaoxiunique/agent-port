import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:agent_port/data/models/sessions.dart';

void main() {
  test('parses a real /api/sessions payload', () {
    // Captured verbatim from the amux serve daemon.
    final json = jsonDecode('''
    {"ok":true,"agents":[
      {"agent":"claude","sessions":[
        {"id":"9f5202fb-d2c2-4a11-81b5-06624f6c16a2","modified":1785924365.692,
         "size":555184,"summary":"分析 IPA 包跳转 schema"}]},
      {"agent":"codex","sessions":[
        {"id":"019fc770-b505-7b61-b9d6-818cd1b2bf7b","modified":1785833080.0,
         "size":285000,"summary":null}]}]}
    ''') as Map<String, dynamic>;

    final res = SessionsResponse.fromJson(json);
    expect(res.ok, isTrue);
    expect(res.agents, hasLength(2));

    final claude = res.agents.first;
    expect(claude.agent, 'claude');
    expect(claude.sessions.single.summary, '分析 IPA 包跳转 schema');
    expect(claude.sessions.single.size, 555184);

    // A null summary must survive rather than throw — Codex records no title.
    expect(res.agents.last.sessions.single.summary, isNull);
  });

  test('resume request serializes to the camelCase the host expects', () {
    const req = ResumeSessionRequest(
      path: '/tmp/p', agent: 'claude', sessionId: 'abc', suffix: 'debug');
    expect(req.toJson(), {
      'path': '/tmp/p', 'agent': 'claude', 'sessionId': 'abc', 'suffix': 'debug',
    });
  });

  test('parses a resume response', () {
    final r = ResumeSessionResponse.fromJson(
      jsonDecode('{"ok":true,"session":"cc_reverse_bb8c2d50-debug"}')
          as Map<String, dynamic>);
    expect(r.ok, isTrue);
    expect(r.session, 'cc_reverse_bb8c2d50-debug');
  });
}
