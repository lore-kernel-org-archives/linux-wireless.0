Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24786 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754667AbcHXMaS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 08:30:18 -0400
From: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "Kushwaha, Purushottam" <pkushwah@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Malinen, Jouni" <jouni@qca.qualcomm.com>,
        "Kondabattini, Ganesh" <ganeshk@qti.qualcomm.com>,
        "Kalikot Veetil, Mahesh Kumar" <mkalikot@qca.qualcomm.com>,
        "Hullur Subramanyam, Amarnath" <amarnath@qca.qualcomm.com>,
        "Kumar, Deepak (QCA)" <djindal@qti.qualcomm.com>
Subject: RE: [PATCH] cfg80211: Add support for user configurable beacon data
 rate
Date: Wed, 24 Aug 2016 12:30:10 +0000
Message-ID: <17fc8f16b6184c2ba09146faefd2bc8c@aphydexm01f.ap.qualcomm.com> (sfid-20160824_143038_511563_6F96644A)
References: <1470371701-13074-1-git-send-email-pkushwah@qti.qualcomm.com>
         <1470387784.2977.30.camel@sipsolutions.net>
         <92b06d4df5984e6ea91081126e096a96@aphydexm01f.ap.qualcomm.com>
 <1470513454.3374.1.camel@sipsolutions.net>
In-Reply-To: <1470513454.3374.1.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkl0IGNoZWNrcyB0aGF0IGV2ZXJ5dGhpbmcgbWF0Y2hlcyB1cCB3aXRoIGNhcGFiaWxpdGllcywg
YnV0IGl0IGRvZXNuJ3QgY2hlY2sgdGhhdCBpZiB5b3Ugc3BlY2lmaWVkIE5MODAyMTFfQVRUUl9U
WF9SQVRFUyB5b3UgZGlkbid0IGRvIHNvbWV0aGluZyBzdHVwaWQgbGlrZSBzcGVjaWZ5aW5nIGl0
IGZvciAyLjRHSHogd2hpbGUgeW91ciBBUCBpcyA+c3RhcnRpbmcgdXAgb24gNUdIei4NClRoYW5r
cyBmb3IgdGhlIHN1Z2dlc3Rpb24gLiBXZSBzaGFsbCBlbnN1cmUgdG8gY29uc2lkZXIgdGhlIGJl
YWNvbiByYXRlcyBjb25maWd1cmVkIG9uIHRoZSBzcGVjaWZpYyBiYW5kIGNvcnJlc3BvbmRpbmcg
dG8gdGhlIENoYW5uZWwgb24gd2hpY2ggdGhlIEFQIGlzIGdldHRpbmcgc3RhcnRlZC4gbmw4MDIx
MV9wYXJzZV90eF9iaXRyYXRlX21hc2sgc2hhbGwgYW55d2F5cyB2YWxpZGF0ZSB0aGUgYmVhY29u
IHJhdGVzIGNvbmZpZ3VyZWQgd2l0aCB0aGUgb25lcyBzdXBwb3J0ZWQgLyBhZHZlcnRpc2VkIG9u
IGEgc3BlY2lmaWMgYmFuZC4gDQoNCj5JdCBhbHNvIGRvZXNuJ3QgY2hlY2sgdGhhdCB5b3Ugc3Bl
Y2lmaWVkIGV4YWN0bHkgb25lIHJhdGUsIGJ1dCBpdCdzIG5vdCBjbGVhciBob3cgZWxzZSB0aGlz
IHdvdWxkIHdvcms/DQpJIGNhbiB0aGluayBvZiB0aGUgZm9sbG93aW5nIG9wdGlvbnMgaGVyZSAu
IA0KMS4gQ29uc2lkZXIgdGhlc2UgcmF0ZXMgYXMgb25seSB0aGUgcHJlZmVyZW5jZSAoIGluIG9y
ZGVyICkgdG8gdGhlIGhvc3QgZHJpdmVyICwgYnV0IHRoZSBVc2VyIHNwYWNlIHdvdWxkIGhhdmUg
bm8gd2F5IG9mIGtub3dpbmcgd2hhdCB0aGUgZHJpdmVyIGhhcyBzZWxlY3RlZC4NCjIuIExpbWl0
IHRoaXMgYmVhY29uIHJhdGUgdG8gb25seSBvbmUgLiBjZmc4MDIxMSB0byB2ZXJpZnkgdGhhdCB0
aGVyZSBpcyBleGFjdGx5IG9uZSByYXRlIHRvIGJlIHNwZWNpZmllZC4gDQoNCklzIG9wdGlvbiAy
IGEgdmlhYmxlIG9wdGlvbiA/DQoNClJlZ2FyZHMsDQpTdW5pbA0KDQotLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KRnJvbTogSm9oYW5uZXMgQmVyZyBbbWFpbHRvOmpvaGFubmVzQHNpcHNvbHV0
aW9ucy5uZXRdIA0KU2VudDogU3VuZGF5LCBBdWd1c3QgNywgMjAxNiAxOjI4IEFNDQpUbzogVW5k
ZWthcmksIFN1bmlsIER1dHQgPHVzZHV0dEBxdGkucXVhbGNvbW0uY29tPjsgS3VzaHdhaGEsIFB1
cnVzaG90dGFtIDxwa3VzaHdhaEBxdGkucXVhbGNvbW0uY29tPg0KQ2M6IGxpbnV4LXdpcmVsZXNz
QHZnZXIua2VybmVsLm9yZzsgTWFsaW5lbiwgSm91bmkgPGpvdW5pQHFjYS5xdWFsY29tbS5jb20+
OyBLb25kYWJhdHRpbmksIEdhbmVzaCA8Z2FuZXNoa0BxdGkucXVhbGNvbW0uY29tPjsgS2FsaWtv
dCBWZWV0aWwsIE1haGVzaCBLdW1hciA8bWthbGlrb3RAcWNhLnF1YWxjb21tLmNvbT47IEh1bGx1
ciBTdWJyYW1hbnlhbSwgQW1hcm5hdGggPGFtYXJuYXRoQHFjYS5xdWFsY29tbS5jb20+DQpTdWJq
ZWN0OiBSZTogW1BBVENIXSBjZmc4MDIxMTogQWRkIHN1cHBvcnQgZm9yIHVzZXIgY29uZmlndXJh
YmxlIGJlYWNvbiBkYXRhIHJhdGUNCg0KT24gU2F0LCAyMDE2LTA4LTA2IGF0IDA0OjM4ICswMDAw
LCBVbmRla2FyaSwgU3VuaWwgRHV0dCB3cm90ZToNCj4gPiANCj4gPiBEb2Vzbid0IHRoaXMgaGF2
ZSB0byBjaGVjayB0aGF0IGl0IGFjdHVhbGx5IGdvdCBpbmZvcm1hdGlvbiBmb3IgdGhlIA0KPiA+
IHJpZ2h0IGJhbmQ/DQo+IEhpIEpvaGFubmVzICwNCj4gbmw4MDIxMV9wYXJzZV90eF9iaXRyYXRl
X21hc2sgKCBhIG5ldyB3cmFwcGVyIHRvIHRoZSBleGlzdGluZyANCj4gZnVuY3Rpb25hbGl0eSBp
biBubDgwMjExX3NldF90eF9iaXRyYXRlX21hc2sgKSBkb2VzIHRoaXMgLCBpc24ndCA/DQo+IA0K
SXQgY2hlY2tzIHRoYXQgZXZlcnl0aGluZyBtYXRjaGVzIHVwIHdpdGggY2FwYWJpbGl0aWVzLCBi
dXQgaXQgZG9lc24ndCBjaGVjayB0aGF0IGlmIHlvdSBzcGVjaWZpZWQgTkw4MDIxMV9BVFRSX1RY
X1JBVEVTIHlvdSBkaWRuJ3QgZG8gc29tZXRoaW5nIHN0dXBpZCBsaWtlIHNwZWNpZnlpbmcgaXQg
Zm9yIDIuNEdIeiB3aGlsZSB5b3VyIEFQIGlzIHN0YXJ0aW5nIHVwIG9uIDVHSHouDQoNCkl0IGFs
c28gZG9lc24ndCBjaGVjayB0aGF0IHlvdSBzcGVjaWZpZWQgZXhhY3RseSBvbmUgcmF0ZSwgYnV0
IGl0J3Mgbm90IGNsZWFyIGhvdyBlbHNlIHRoaXMgd291bGQgd29yaz8NCg0Kam9oYW5uZXMNCg==
