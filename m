Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41245 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdALNu0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 08:50:26 -0500
From: "Vamsi, Krishna" <vamsin@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3 1/3] cfg80211: Add support to sched scan to report
 better BSSs
Date: Thu, 12 Jan 2017 13:50:14 +0000
Message-ID: <b2eed75062454040bc84091ec35a2546@aphydexm01b.ap.qualcomm.com> (sfid-20170112_145029_891481_0E7270F7)
References: <1483984388-30237-1-git-send-email-jouni@qca.qualcomm.com>
         <25527a43-0458-f9f4-9afb-f5986dffbae1@broadcom.com>
         <54d6fd2bc55f4c9290402e692ed27005@aphydexm01b.ap.qualcomm.com>
 <1484140967.29931.6.camel@sipsolutions.net>
In-Reply-To: <1484140967.29931.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvaGFubmVzIEJlcmcgW21h
aWx0bzpqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0XQ0KIA0KPiA+ID4gU28geW91IHNlZSBhIHVz
ZS1jYXNlIGZvciBkb2luZyBhIHNjYW4gd2l0aCBAcmVsYXRpdmVfcnNzaSBiZWluZw0KPiA+ID4g
emVybywgcmlnaHQ/DQo+ID4NCj4gPiBZZXMuIFplcm8gdmFsdWUgZm9yIHJlbGF0aXZlX3Jzc2kg
aXMgYWxzbyB2YWxpZC4NCj4gDQo+IE9yIG5lZ2F0aXZlIGV2ZW4sIEkgZ3Vlc3M/DQoNClllcywg
dGhpcyBjYW4gYmUgbmVnYXRpdmUgYWxzby4NCiANCj4gPiBJIGxpa2UgdG8gbGVhdmUgdGhpcyBh
cyBzOCBvbmx5LiBUaGlzIHdpbGwgbGVhdmUgbW9yZSBmbGV4aWJpbGl0eSB0bw0KPiA+IHVzZXJz
cGFjZSBlc3BlY2lhbGx5IGluIGNhc2Ugb2YgbW9yZSB0aGFuIHR3byBiYW5kcyBpbiBmdXR1cmUu
DQo+IA0KPiBJIGd1ZXNzIHlvdSBzaG91bGQgcmV3b3JkIHRoYXQgLSBpbnN0ZWFkIG9mICJiZXR0
ZXIiIGl0IHNob3VsZCBzYXkgaG93IHRoaXMgdmFsdWUNCj4gaXMgYXBwbGllZCwgYXMgYSBkZWx0
YSB0byB0aGUgY3VycmVudCBSU1NJLCBhbmQgdGhlbiByZXBvcnRpbmcgdGhlIHJlc3VsdC4NCj4g
DQo+IEhvd2V2ZXIsIEkgZG9uJ3QgdW5kZXJzdGFuZCB5b3VyIGNvbW1lbnQgYWJvdXQgdGhpcyBi
ZWluZyByZWxhdGVkIHRvIG11bHRpcGxlDQo+IGJhbmRzLCBjYW4geW91IGNsYXJpZnk/IFRoZSBy
ZWxhdGl2ZV9yc3NpIGp1c3QgZGV0ZXJtaW5lcyB0aGUgZmlsdGVyIGFmdGVyIHRoZQ0KPiBhZGp1
c3RtZW50KHMpIGRvbmUgd2l0aCByc3NpX2FkanVzdCwgYnV0IGhvdyBjb3VsZCBpdCBiZSByZWxl
dmFudD8NCj4gDQo+IFRoZSBvbmx5IHVzZSBjYXNlIGZvciByZWxhdGl2ZV9yc3NpIGJlaW5nIG5l
Z2F0aXZlIHdvdWxkIGJlIHdoZW4geW91IGFjdHVhbGx5DQo+ICp3YW50KiB0byBzZWUgc2xpZ2h0
bHkgd29yc2UgbmV0d29ya3MgdGhhbiB0aGUgb25lIHlvdSdyZSBjb25uZWN0ZWQgdG8sIGUuZy4g
dG8NCj4gZGV0ZXJtaW5lIGlmIHlvdSBzaG91bGQgdXNlIHRoZW0gYmVjYXVzZSB0aGV5IGhhdmUg
YmV0dGVyIHBhcmFtZXRlcnMgKGUuZy4NCj4gSFQvVkhUIG9yIHNvb24gSEUpLg0KDQpJIHdvdWxk
IGxpa2UgdG8gc3dhbGxvdyBteSB3b3Jkcy4gVGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIHdpdGgg
bXkgZWFybGllciB0aGlua2luZy4NCiANCiANCj4gPg0KPiA+IEByZWxhdGl2ZV9yc3NpIGlzIHZh
bGlkIG9ubHkgd2hlbiBAcmVsYXRpdmVfcnNzaV9zZXQgaXMgc2V0IHRvIHRydWUNCj4gPiBhbmQg
QHJzc2lfYWRqdXN0IGlzIHZhbGlkIG9ubHkgd2hlbiBAcmVsYXRpdmVfcnNzaSBpcyB2YWxpZC4g
SSB0aGluaw0KPiA+IHRoYXQgaXMgdW5kZXJzdGFuZGFibGUgdG8gZHJpdmVycyBhbmQgdGhlcmUg
aXMgbm8gbmVlZCBvZiBleHBsaWNpdA0KPiA+IGNoZWNrIGhlcmUuDQo+IA0KPiBJdCB3b3VsZG4n
dCBiZSBwcm9ibGVtYXRpYyB0byBwYXJzZSB0aGUgUlNTSV9BREpVU1Qgb25seSB3aGVuIHRoZSBv
dGhlcnMgYXJlDQo+IHByZXNlbnQgdGhvdWdoLCBzbyB0aGF0IGEgZHJpdmVyIGNvdWxkIGFwcGx5
IHRoZSByc3NpX2FkanVzdCB1bmNvbmRpdGlvbmFsbHkNCj4gKHNpbmNlLCBpZiBpdCdzIG5vdCBw
YXJzZWQsIHRoZSBkZWx0YSB3aWxsIGJlIDAuKQ0KDQpTdXJlLCB3aWxsIHRha2UgY2FyZSBvZiB0
aGlzIGluIHRoZSBuZXh0IHBhdGNoLg0KDQpUaGFua3MsDQpWYW1zaQ0K
