Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21461 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756972Ab0KVUWx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 15:22:53 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 12:22:40 -0800
From: Michael Green <Michael.Green@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 22 Nov 2010 12:22:51 -0800
Subject: [PATCH] wireless-regdb: update rules for DE
Message-ID: <93781E992CBA7843962D8B0E7D683F3C1633485053@SC1EXMB-MBCL.global.atheros.com>
References: <20100525151429.GC6342@tpkurt2.garloff.de>
 <1290029817-711-1-git-send-email-linville@tuxdriver.com>
 <AANLkTimDkoqNbkFWDsU2HgFK3926gRpcBbokX_GL5sSc@mail.gmail.com>
 <93781E992CBA7843962D8B0E7D683F3C163340D5AE@SC1EXMB-MBCL.global.atheros.com>
 <20101119020414.GB2512@tuxdriver.com>
 <20101119091450.GD12228@tpkurt2.nue.garloff.de>
 <93781E992CBA7843962D8B0E7D683F3C16334843DD@SC1EXMB-MBCL.global.atheros.com>
 <AANLkTi=ySDQtw+M6ATV47HszkJN7vfR7q+FOC6-OBqjk@mail.gmail.com>
 <93781E992CBA7843962D8B0E7D683F3C1633484F57@SC1EXMB-MBCL.global.atheros.com>
 <AANLkTimbCzK6RPCnc0T117D0X+Yvi8S3j3L9aG74L=Jg@mail.gmail.com>
In-Reply-To: <AANLkTimbCzK6RPCnc0T117D0X+Yvi8S3j3L9aG74L=Jg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WWVzLCBlYWNoIHBhdGNoIGFmZmVjdHMgb25lIGNvdW50cnkgb25seS4gIE15IHBvaW50IGlzIHRo
YXQgSSBiZWxpZXZlIGV2ZXJ5IEVVIGNvdW50cnkgc2hvdWxkIGJlIHNldCB0byB0aGUgZXhhY3Qg
c2FtZSBzZXR0aW5ncyBmb3IgY2hhbm5lbCwgcG93ZXIsIERGUyBhbmQgaW5kb29yL291dGRvb3Ig
ZmxhZ3MuDQoNClNvIHdhcyB3b25kZXJpbmcgaWYgdGhlc2UgbmV3IERFIHNldHRpbmdzIG1ha2Ug
REUgaW4gbGluZSB3aXRoIGFsbCB0aGUgb3RoZXIgRVUgY291bnRyaWVzLiBPciBhcmUgYWxsIHRo
ZSBFVSBjb3VudHJpZXMgYWxsIG92ZXIgdGhlIG1hcCAoc28gdG8gc3BlYWspLg0KDQpUaGUgaXNz
dWUgaXMgdGhhdCBzb21lIEVVIGNvdW50cmllcyBzdGF0ZSBzb21lIGRpZmZlcmVuY2VzIGluIHNw
ZWN0cnVtIGFsbG9jYXRpb24gcnVsZXMsIGJ1dCBhbGwgV0xBTiBwcm9kdWN0cyBtdXN0IGNvbXBs
eSB3aXRoIHRoZSBoYXJtb25pemVkIGNvbmZvcm1hbmNlIHN0YW5kYXJkIChFTjMwMSA4MzkpIHdo
aWNoIHNwZWNpZmllcyB0aGUgc2FtZSBzZXQgb2YgcnVsZXMsIHRoYXQgSSBiZWxpZXZlIGFsbCBX
TEFOIHByb2R1Y3RzIHNob3VsZCBiZSBzZXQgdG8uDQoNCg0KDQpNaWNoYWVsIEdyZWVuDQpBdGhl
cm9zIENvbW11bmljYXRpb25zLCBJbmMuDQptZ3JlZW5AYXRoZXJvcy5jb20NCkRlc2s6ICAgKzEt
NzgxLTQwMC0xNDkxDQpNb2JpbGU6ICsxLTUwOC0zODAtNDkyMQ0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogTHVpcyBSLiBSb2RyaWd1ZXogW21haWx0bzptY2dyb2ZAZ21haWwu
Y29tXSANClNlbnQ6IE1vbmRheSwgTm92ZW1iZXIgMjIsIDIwMTAgMjozNiBQTQ0KVG86IE1pY2hh
ZWwgR3JlZW4NCkNjOiBsaW51eC13aXJlbGVzcw0KU3ViamVjdDogUmU6IFtQQVRDSF0gd2lyZWxl
c3MtcmVnZGI6IHVwZGF0ZSBydWxlcyBmb3IgREUNCg0KT24gTW9uLCBOb3YgMjIsIDIwMTAgYXQg
MTE6MDAgQU0sIE1pY2hhZWwgR3JlZW4NCjxNaWNoYWVsLkdyZWVuQGF0aGVyb3MuY29tPiB3cm90
ZToNCj4gVGhhbmtzLiDCoEkgdW5kZXJzdGFuZC9hZ3JlZSB3aXRoIHRoYXQuIEJ1dCBhIGR1bWIg
cXVlc3Rpb24uLi5hcmUgYWxsIG90aGVyIEVVIGNvdW50cmllcyBzZXQgdGhlIHNhbWUgd2F5IG5v
dz8NCg0KSGV5IE1pY2hhZWwsIG5vIHRoZXkgYXJlIG5vdCwgZWFjaCBwYXRjaCBhZGRyZXNzZXMg
anVzdCBvbmUgY291bnRyeSBhdCBhIHRpbWUuDQoNCiAgTHVpcw0K
