Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39455 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933510AbeAYDlK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 22:41:10 -0500
From: Pkshih <pkshih@realtek.com>
To: "johannes.berg@intel.com" <johannes.berg@intel.com>
CC: "kbuild-all@01.org" <kbuild-all@01.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>
Subject: Re: [mac80211-next:master 3/5] net//wireless/wext-compat.c:1351:9: warning: function returns address of local variable
Date: Thu, 25 Jan 2018 03:41:00 +0000
Message-ID: <1516851660.3774.13.camel@realtek.com> (sfid-20180125_044130_173566_885F00F7)
References: <201801222115.gqohMHIk%fengguang.wu@intel.com>
In-Reply-To: <201801222115.gqohMHIk%fengguang.wu@intel.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE4LTAxLTIyIGF0IDEzOjAwICswMDAwLCBrYnVpbGQgdGVzdCByb2JvdCB3cm90
ZToNCj4gdHJlZTrCoMKgwqBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9qYmVyZy9tYWM4MDIxMS1uZXh0LmdpDQo+IHQgbWFzdGVyDQo+IGhlYWQ6wqDCoMKg
MDc2ZGM2NzFlZTlmYTM3NGU3N2MzZDA1OTI1ZGFmYjc1YjIzYTc0Yw0KPiBjb21taXQ6IGMxNzll
OTE1MTJjYWIwMWU4M2JlMzVhNjBlYWVkYTBmMTcwYTkxMDEgWzMvNV0gY2ZnODAyMTE6IHdleHQ6
IGRvbid0DQo+IHVzZSBzdGF0aWMgc3RydWN0DQo+IGNvbmZpZzogeDg2XzY0LXJhbmRjb25maWct
eDAxNi0wMTIyMTgzNCAoYXR0YWNoZWQgYXMgLmNvbmZpZykNCj4gY29tcGlsZXI6IGdjYy03IChE
ZWJpYW4gNy4yLjAtMTIpIDcuMi4xIDIwMTcxMDI1DQo+IHJlcHJvZHVjZToNCj7CoMKgwqDCoMKg
wqDCoMKgwqBnaXQgY2hlY2tvdXQgYzE3OWU5MTUxMmNhYjAxZTgzYmUzNWE2MGVhZWRhMGYxNzBh
OTEwMQ0KPsKgwqDCoMKgwqDCoMKgwqDCoCMgc2F2ZSB0aGUgYXR0YWNoZWQgLmNvbmZpZyB0byBs
aW51eCBidWlsZCB0cmVlDQo+wqDCoMKgwqDCoMKgwqDCoMKgbWFrZSBBUkNIPXg4Nl82NMKgDQo+
wqANCj4gQWxsIHdhcm5pbmdzIChuZXcgb25lcyBwcmVmaXhlZCBieSA+Pik6DQo+wqANCj7CoMKg
wqDCoG5ldC8vd2lyZWxlc3Mvd2V4dC1jb21wYXQuYzogSW4gZnVuY3Rpb24gJ2NmZzgwMjExX3dp
cmVsZXNzX3N0YXRzJzoNCj4gPj4gbmV0Ly93aXJlbGVzcy93ZXh0LWNvbXBhdC5jOjEzNTE6OTog
d2FybmluZzogZnVuY3Rpb24gcmV0dXJucyBhZGRyZXNzIG9mDQo+IGxvY2FsIHZhcmlhYmxlIFst
V3JldHVybi1sb2NhbC1hZGRyXQ0KPsKgwqDCoMKgwqDCoHJldHVybiAmd3N0YXRzOw0KPsKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgXn5+fn5+fg0KPsKgDQoNCkhpIEpvaGFubmVzLA0KDQpJbiBj
b21taXQgYzE3OWU5MTUxLCB5b3UgcmVtb3ZlICdzdGF0aWMnIGZyb20gc3RydWN0LCBidXQgZnVu
Y3Rpb24gcmV0dXJuIHRoZQ0KYWRkcmVzcyBvZiBsb2NhbCB2YXJpYWJsZSBhcyBrYnVpbGQgcm9i
b3QgbWVudGlvbmVkLiBJdCBpcyBhIHByb2JsZW0sIGJ1dA0KbXkgcHJpb3IgZXhwZXJpbWVudCBs
b29rcyBmaW5lLiBIZW5jZSwgSSBjaGVjayB0aGUgY2FsbGVycyBvZiBnZXRfd2lyZWxlc3Nfc3Rh
dHMoKSwNCmFuZCBmb3VuZCB0aGV5IHVzZSB0aGUgYWRkcmVzcyB0aGF0IHBvaW50cyB0byBzdGFj
ayBpbW1lZGlhdGVseSwgc28gY29udGVudCBvZg0Kc3RhY2sgd2Fzbid0IGJyb2tlbiBsdWNraWx5
Lg0KDQpTbywgcGxlYXNlIHJlY2FsbCB0aGUgJ3N0YXRpYycgb2YgJ3N0cnVjdCBpd19zdGF0aXN0
aWNzIHdzdGF0cycuDQpUaGFua3MNClBLDQoNCg==
