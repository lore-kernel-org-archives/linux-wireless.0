Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:36143 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758792AbdKOTVn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Nov 2017 14:21:43 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: RE: [PATCH] mac80211: Update last_ack status for all except probing
 frames
Date: Wed, 15 Nov 2017 19:21:40 +0000
Message-ID: <839c3938efae497e9058391fd4be4817@NALASEXR01H.na.qualcomm.com> (sfid-20171115_202148_875833_1D67FA68)
References: <1509409746-26592-1-git-send-email-rmanohar@qti.qualcomm.com>
         <1509964164.2669.0.camel@sipsolutions.net>
         <8bb232d231884f9595c81f945a5eef4f@NALASEXR01H.na.qualcomm.com>
         <49241af7-a50f-5758-0c7e-77f2fae5d93d@quantenna.com>
         <96799d352b7347a8a9092bb37f1cd8d9@NALASEXR01H.na.qualcomm.com>
 <1510565141.30497.6.camel@sipsolutions.net>
In-Reply-To: <1510565141.30497.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBPbiBNb24sIDIwMTctMTEtMDYgYXQgMjA6MjAgKzAwMDAsIFJhamt1bWFyIE1hbm9oYXJhbiB3
cm90ZToNCj4gPiA+ID4gRm9yIHN0ZWVyaW5nIGFuIGlkbGUgc3RhdGlvbiBmcm9tIG9uZSBCU1Mg
dG8gYW5vdGhlciwgdGhlIHN0ZWVyaW5nDQo+ID4gPiA+IGFwcGxpY2F0aW9uIGhhcyB0byBrbm93
IHRoZSBhY3R1YWwgc3RhdGlvbiBpZGxlIHBlcmlvZC4gQnV0IGlmIHRoZQ0KPiA+ID4gPiBpZGxl
IHBlcmlvZCBpcyBjbGVhcmVkIGJ5IGFwX21heF9pbmFjdGl2aXR5LCB0aGUgc3RlZXJpbmcNCj4g
PiA+ID4gYXBwbGljYXRpb24gY2Fubm90IHN0ZWVyIHRoZSBzdGF0aW9uIGV2ZW4gdGhvdWdoIHRo
ZSBzdGF0aW9uIGlzDQo+ID4gPiA+IG5vdCBzZW5kaW5nIG9yIHJlY2VpdmluZw0KPiA+ID4NCj4g
PiA+IGFueSBkYXRhIG9yIG1nbXQuIGZyYW1lLg0KPiANCj4gSSBndWVzcyB5b3Ugd2FudCBzb21l
dGhpbmcgZWxzZS4gV2h5IGV2ZW4gY29uc2lkZXIgYSBzdGF0aW9uIHRoYXQncyBzZW5kaW5nDQo+
IG1nbXQgZnJhbWVzIGFzIG5vbi1pZGxlPw0KPiANCj4gWW91IGNhbiBqdXN0IHVzZSB0aGUgZGF0
YSBUWC9SWCBjb3VudGVycyB0byBmaWd1cmUgb3V0IGlmIHRoZSBzdGF0aW9uIGhhcyBiZWVuDQo+
IGlkbGUuDQo+IA0KSG1tLi4gQnV0IHBvbGxpbmcgVFgvUlggY291bnRlcnMgd2lsbCBub3QgZ2l2
ZSBleGFjdCBhY3Rpdml0eSB0aW1lLiBNb3Jlb3Zlcg0KSXQgd2lsbCBiZSB1c2VmdWwgaWYgU1RB
J3MgbGFzdCBkYXRhIGFjdGl2aXR5IHRzdGFtcCBpcyBsb2dnZWQgaW4gc3RhdGlvbiBkdW1wLiBO
bz8NCg0KPiBZb3UndmUgbm90IGNvbnZpbmNlZCBtZSB0aGF0IGNoYW5naW5nIHRoZSBjdXJyZW50
IGxvZ2ljIGhlcmUgbWFrZXMgYW55IHNlbnNlLg0KPiANCkkgdGhvdWdodCBhZGRpbmcgbmV3IGlu
YWN0aXZlIHRpbWUgYXR0cmlidXRlIG1heSBjb25mbGljdCB3aXRoIGV4aXN0aW5nIGxhc3RfYWN0
aXZlDQppbmZvLiAgQXMgSWdvciBtZW50aW9uZWQgZWFybGllciwgd2hhdCBpcyB5b3VyIHRob3Vn
aHQgb2YgYWRkaW5nIG5ldyBhdHRyaWJ1dGUgDQoic3RhX2xhc3RfZGF0YV9hY3RpdmUiIHRvIG1v
bml0b3IgZGF0YSBmcmFtZS4NCg0KQW55IHN1Z2dlc3Rpb25zIGFyZSB3ZWxjb21lLg0KDQotUmFq
a3VtYXINCg0K
