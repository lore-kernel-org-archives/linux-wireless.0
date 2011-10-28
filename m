Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4732 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1J1HsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Oct 2011 03:48:21 -0400
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 28 Oct 2011 00:48:06 -0700
Subject: RE: [RFC v2 13/12] cfg80211/mac80211: allow management TX to
 not wait for ACK
Message-ID: <400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com> (sfid-20111028_094825_027926_E333759E)
References: <20111021142322.229128720@sipsolutions.net> (
 sfid-20111021_162510_209354_8FBBB6EB)
 <1319743973.32221.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319743973.32221.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBTZW50OiBkb25kZXJkYWcgMjcgb2t0b2JlciAyMDExIDIxOjMzDQo+IEZyb206IEpvaGFubmVz
IEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPg0KPiANCj4gRm9yIHByb2JlIHJlc3BvbnNl
cyBpdCBjYW4gYmUgdXNlZnVsIHRvIG5vdCB3YWl0IGZvciBBQ0sNCj4gdG8gc2F2ZSBhaXJ0aW1l
LCBzbyBhbGxvdyB1c2Vyc3BhY2UgdG8gcmVxdWVzdCBub3Qgd2FpdGluZw0KPiB3aXRoIGEgbmV3
IG5sODAyMTEgZmxhZy4NCj4gDQo+IFNpbmNlIG1hYzgwMjExIG5lZWRzIHRvIGJlIHVwZGF0ZWQg
Zm9yIHRoZSBuZXcgZnVuY3Rpb24NCj4gcHJvdG90eXBlIGFueXdheSBpbXBsZW1lbnQgaXQgcmln
aHQgYXdheSAtLSBpdCdzIGp1c3QgYQ0KPiBmZXcgbGluZXMgb2YgY29kZS4NCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPg0KPiAtLS0N
Cg0KSGkgSm9oYW5uZXMsDQoNCkkgd291bGQgZXhwZWN0IHRoaXMgdG8gYWZmZWN0IHRoZSBkdXJh
dGlvbiBmaWVsZCBpbiB0aGUNCjgwMi4xMSBoZWFkZXIgdG8gaW5kaWNhdGUgdGhlIHNob3J0ZXIg
dXNlIG9mIHRoZSBtZWRpdW0uDQpHb2luZyB0aHJvdWdoIHlvdXIgcGF0Y2ggSSBhbSBub3Qgc3Vy
ZSB0aGlzIGlzIGRvbmUuDQoNCkdyLiBBdlMNCg==

