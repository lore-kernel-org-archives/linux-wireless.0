Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18232 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdCBLtE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 06:49:04 -0500
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCHv2 3/4] cfg80211: Add Support set btcoex priority value
Date: Thu, 2 Mar 2017 11:48:48 +0000
Message-ID: <b55e902d1a5445feb3058cee1118ae39@aphydexm01f.ap.qualcomm.com> (sfid-20170302_124908_604043_883BC4DC)
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
         <1488029873-14600-4-git-send-email-c_traja@qti.qualcomm.com>
 <1488444659.8390.8.camel@sipsolutions.net>
In-Reply-To: <1488444659.8390.8.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PiBJcyB0aGVyZSBtdWNoIHBvaW50IGluIGhhdmluZyA0IHJhdGhlciB0aGFuIGp1c3QgMiBwYXRj
aGVzPw0KPg0KW1RhbWl6aF0gWWVzLCBJIGFncmVlIHRvIGl0LiANCj4gDQo+ID4gKwlpbnTCoMKg
wqDCoMKgKCpzZXRfYnRjb2V4KShzdHJ1Y3Qgd2lwaHkgKndpcGh5LCBib29sIGVuYWJsZWQsDQo+
ID4gKwkJCcKgwqDCoMKgwqDCoGludCBidGNvZXhfcHJpb3JpdHkpOw0KPiANCj4gU2hvdWxkbid0
IHRoYXQgYmUgdTMyIGFzIGEgYml0bWFwPw0KPiANCltUYW1pemhdIFllcy4NCg0KPiA+ICsJYm9v
bCBidGNvZXhfcHJpb3JpdHlfc3VwcG9ydDsNCj4gDQo+IFdoeSBub3QgdXNlIGFuIGV4dGVuZGVk
IG5sODAyMTEgZmVhdHVyZSBmbGFnIGRpcmVjdGx5Pw0KPiANCltUYW1pemhdIE9rIHN1cmUuIEkn
bGwgdXNlIGV4dGVuZGVkIG5sODAyMTEgZmVhdHVyZSBmbGFnLg0KDQo+ID4gKyAqIEBOTDgwMjEx
X0FUVFJfQlRDT0VYX1BSSU9SSVRZOiBUaGlzIGlzIGZvciB0aGUgZHJpdmVyIHdoaWNoDQo+ID4g
KyAqwqDCoMKgwqDCoHN1cHBvcnQgYnRjb2V4IHByaW9yaXR5IGZlYXR1cmUuIEl0IHVzZWQgd2l0
aA0KPiA+ICVOTDgwMjExX0NNRF9TRVRfQlRDT0VYLg0KPiA+ICsgKsKgwqDCoMKgwqBUaGlzIHdp
bGwgaGF2ZSB1MzIgQklUTUFQIHZhbHVlIHdoaWNoIHJlcHJlc2VudHMNCj4gPiArICrCoMKgwqDC
oMKgZnJhbWUoYmssIGJlLCB2aSwgdm8sIG1nbXQsIGJlYWNvbikgdHlwZSBhbmQgdGhhdCB3aWxs
IGhhdmUNCj4gPiBtb3JlDQo+ID4gKyAqwqDCoMKgwqDCoHByaW9yaXR5IHRoYW4gYSBCVCB0cmFm
ZmljLg0KPiANCj4gSSB0aGluayB5b3UgbmVlZCB0byBkZWZpbmUgdGhlIGJpdHMgc29tZXdoZXJl
IGluIGFuIGVudW0gLSBpLmUuIHdoaWNoIG9uZSBpcyBWTywNCj4gVkksIC4uLg0KPg0KW1RhbWl6
aF0gb2sgc3VyZS4gSXMgdGhpcyBmb3IgZG9jdW1lbnRhdGlvbiBwdXJwb3NlIG9yIGRvIHlvdSB3
YW50IG1lIHRvIHVzZSB0aGF0IA0KZW51bSBmb3Igc29tZXRoaW5nIGVsc2U/DQogDQo+ID4gKwlp
bnQgYnRjb2V4X3ByaW9yaXR5ID0gLTE7DQo+IA0KPiBUaGF0IC0xIGlzIHByZXR0eSB1c2VsZXNz
LCBpZiB0aGUgZHJpdmVyIGRvZXNuJ3Qgc3VwcG9ydCBpdCwgaG9wZWZ1bGx5IGl0IHdvbid0IGxv
b2sNCj4gYXQgdGhlIHZhbHVlIGF0IGFsbD8NCj4gDQpbVGFtaXpoXSBPayBzdXJlDQo=
