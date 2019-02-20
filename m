Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68E6C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 11:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B58D3206B7
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 11:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfBTLTo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 06:19:44 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38564 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfBTLTn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 06:19:43 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1KBJCEF013672, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1KBJCEF013672
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 20 Feb 2019 19:19:13 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCAS11.realtek.com.tw (172.21.6.12) with Microsoft SMTP Server (TLS) id
 14.3.399.0; Wed, 20 Feb 2019 19:19:12 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Wed, 20 Feb
 2019 19:19:12 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Grant Grundler <grundler@chromium.org>,
        Brian Norris <briannorris@chromium.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 03/13] rtw88: hci files
Thread-Topic: [PATCH v4 03/13] rtw88: hci files
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXJdAKAgBYI04CACS3/wA==
Date:   Wed, 20 Feb 2019 11:19:10 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17AA49B@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190131223609.GA191502@google.com>
 <CANEJEGt4xJ5pTXgqazTVV2MNZy9+SWa6uE+wbE_94aT+FvL-+A@mail.gmail.com>
In-Reply-To: <CANEJEGt4xJ5pTXgqazTVV2MNZy9+SWa6uE+wbE_94aT+FvL-+A@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmFudCBHcnVuZGxl
ciBbbWFpbHRvOmdydW5kbGVyQGNocm9taXVtLm9yZ10NCj4gT24gVGh1LCBKYW4gMzEsIDIwMTkg
YXQgMjozNiBQTSBCcmlhbiBOb3JyaXMgPGJyaWFubm9ycmlzQGNocm9taXVtLm9yZz4NCj4gd3Jv
dGU6DQo+IC4uLg0KPiA+IE9uIFdlZCwgSmFuIDMwLCAyMDE5IGF0IDEyOjAyOjEwUE0gKzA4MDAs
IHloY2h1YW5nQHJlYWx0ZWsuY29tIHdyb3RlOg0KPiAuLi4NCj4gPiA+ICtzdGF0aWMgdm9pZCBy
dHdfcGNpX2RtYV9jaGVjayhzdHJ1Y3QgcnR3X2RldiAqcnR3ZGV2LA0KPiA+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHN0cnVjdCBydHdfcGNpX3J4X3JpbmcgKnJ4X3JpbmcsDQo+ID4g
PiArICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIGlkeCkNCj4gPiA+ICt7DQo+ID4gPiAr
ICAgICBzdHJ1Y3QgcnR3X2NoaXBfaW5mbyAqY2hpcCA9IHJ0d2Rldi0+Y2hpcDsNCj4gPiA+ICsg
ICAgIHN0cnVjdCBydHdfcGNpX3J4X2J1ZmZlcl9kZXNjICpidWZfZGVzYzsNCj4gPiA+ICsgICAg
IHUzMiBkZXNjX3N6ID0gY2hpcC0+cnhfYnVmX2Rlc2Nfc3o7DQo+ID4gPiArICAgICB1MTYgdG90
YWxfcGt0X3NpemU7DQo+ID4gPiArICAgICBpbnQgaTsNCj4gPiA+ICsNCj4gPiA+ICsgICAgIGJ1
Zl9kZXNjID0gKHN0cnVjdCBydHdfcGNpX3J4X2J1ZmZlcl9kZXNjICopKHJ4X3JpbmctPnIuaGVh
ZCArDQo+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBpZHggKiBkZXNjX3N6KTsNCj4gPiA+ICsgICAgIGZvciAoaSA9IDA7IGkgPCAyMDsgaSsr
KSB7DQo+ID4gPiArICAgICAgICAgICAgIHRvdGFsX3BrdF9zaXplID0gbGUxNl90b19jcHUoYnVm
X2Rlc2MtPnRvdGFsX3BrdF9zaXplKTsNCj4gPiA+ICsgICAgICAgICAgICAgaWYgKHRvdGFsX3Br
dF9zaXplKQ0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiA+ICsgICAg
IH0NCj4gPg0KPiA+DQo+ID4gVW1tLCB3aGF0IGFyZSB5b3UgdHJ5aW5nIHRvIGRvIGhlcmU/IFRo
aXMgaXMgYSBub24tc2Vuc2ljYWwgbG9vcC4gSQ0KPiA+ICppbWFnaW5lKiB5b3UncmUgdHJ5aW5n
IHRvIGRvIHNvbWUga2luZCBvZiB0aW1lb3V0IGxvb3AgaGVyZSwNCj4gDQo+IE15IGd1ZXNzIGlz
IHRoaXMgaXMgdHJ5aW5nIHRvIG1pdGlnYXRlIGEgcmFjZSBiZXR3ZWVuIHRoZSBDUFUgcmVhZGlu
Zw0KPiBtZW1vcnkgYW5kIFJUTDg4KiBkZXZpY2UgaW4gdXBkYXRpbmcgdGhpcyB3b3JkIG9mIG1l
bW9yeS4gIFRoaXMgaXMgdGhlDQo+IGZpcnN0IGZ1bmN0aW9uIGNhbGxlZCBpbiB0aGUgcGFja2V0
IHByb2Nlc3NpbmcgbG9vcCBpbg0KPiBydHdfcGNpX3J4X2lzcigpLiBUaGlzIGNvZGUgc3VnZ2Vz
dHMgdGhhdCB0aGUgQ1BVIGlzIHNlZWluZyB0aGUNCj4gaW50ZXJydXB0IGJlZm9yZSB0aGUgUlRM
IGhhcyBmaW5pc2hlZCB1cGRhdGluZyBtZW1vcnkgdmlhIERNQSBhbmQgaXMNCj4gbGlrZWx5IGEg
IkJ1ZyIgaW4gdGhlIFJUTCBkZXZpY2UgZmlybXdhcmUuDQo+IA0KPiBJJ20gc3VnZ2VzdGluZyB0
aGlzIGlzIGEgYnVnIGZvciB0d28gcmVhc29uczoNCj4gMSkgTklDIHZlbmRvcnMgaGlzdG9yaWNh
bGx5IGhhdmUgdHJpZWQgdG8gcmVkdWNlIHBhY2tldCBoYW5kbGluZw0KPiBsYXRlbmN5IGJ5IHNl
bmRpbmcgdGhlIGludGVycnVwdCBhIGZldyBtaWNyb3NlY29uZHMgQkVGT1JFIHRoZSBETUEgaXMN
Cj4gYWN0dWFsbHkgY29tcGxldGVkLiBUaGlzIGhhcyBhbHdheXMgZmFpbGVkIGluIHNvbWUgd2Vp
cmQgd2F5IHdoZW5ldmVyDQo+IHRoZSBQQ0kgaG9zdCBjb250cm9sbGVycyB3ZXJlIGEgYml0IHNs
b3dlciBvciBwZXJoYXBzIGV2ZW4gY29hbGVzY2luZw0KPiBETUEgd3JpdGVzIChvciBzb21ldGhp
bmcgbGlrZSB0aGF0KS4NCj4gDQo+IDIpIFBDSS1FeHByZXNzIGludGVycnVwdHMgYXJlICJJbiBi
YW5kIiAoTVNJIG9yIG5vdCkuIFRoaXMgbWVhbnMgb25jZQ0KPiB0aGUgaW50ZXJydXB0IGFycml2
ZXMsIHRoZSBjb3JyZXNwb25kaW5nIGRldmljZSBkcml2ZXIgc2hvdWxkIGJlIGFibGUNCj4gdG8g
YXNzdW1lIGFsbCBETUEgZnJvbSB0aGUgZGV2aWNlIGlzIGNvbXBsZXRlLiAgVGhpcyByYWNlIGlz
IG9ubHkNCj4gcG9zc2libGUgZm9yICJvdXQgb2YgYmFuZCIgSVJRIGxpbmVzIHdoaWNoIGFyZSBm
b3VuZCBvbiBvdGhlciBidXNzZXMNCj4gYW5kIGhpc3RvcmljIFBDSSBhbmQgUENJLVggcGFyYWxs
ZWwgYnVzc2VzLg0KPiANCj4gIkRNQSBpcyBjb21wbGV0ZSIgZG9lc24ndCBuZWNlc3NhcmlseSBt
ZWFucyBkYXRhIGlzIHZpc2libGUgdG8gQ1BVDQo+IHRob3VnaCBvbiBJbnRlbCBYODYsIGl0IHVz
dWFsbHkgaXMuICBUaGUgRE1BIEFQSSByZXF1aXJlcyBtZW1vcnkNCj4gYWxsb2NhdGVkIHZpYSBw
Y2lfW3pdYWxsb2NfY29uc2lzdGVudCgpIGJlIHZpc2libGUgYW5kIGNhY2hlIGNvaGVyZW50DQo+
IHRob3VnaC4gU28gSSBkb24ndCBleHBlY3QgQ1BVIHRvIHBlcmZvcm0gYW55IGFjdGlvbiB0byBt
YWtlIHRoZSBsYXN0DQo+IGJpdHMgb2YgRE1BJ2QgZGF0YSB2aXNpYmxlIGluIHRoaXMgY2FzZS4g
ICJTdHJlYW1pbmcgRGF0YSIgcmVxdWlyZXMNCj4gcGNpX3VubWFwKiBjYWxscyBvciByZXNwZWN0
IGRtYV9zeW5jX3RvX2NwdSgpIChvciB3aGF0ZXZlciBpdCdzDQo+IGNhbGxlZCkgdG8gZ3VhcmFu
dGVlIHRoZSBkYXRhIGlzIHZpc2libGUgLSB0aGF0J3Mgbm90IHdoYXQgaXMgYmVpbmcNCj4gYWNj
ZXNzZWQgaW4gdGhpcyBjb2RlIHRob3VnaCBBRkFJQ1QuDQo+IA0KPiANCj4gPiBidXQgc2luY2UN
Cj4gPiB0aGVyZSdzIG5vdGhpbmcgdGVsbGluZyB0aGUgY29tcGlsZXIgdGhhdCB0aGlzIGlzIGFu
eXRoaW5nIGJ1dCBub3JtYWwNCj4gPiBtZW1vcnksIHRoaXMgbG9vcCBnZXRzIGZsYXR0ZW5lZCBi
eSB0aGUgY29tcGlsZXIgaW50byBhIHNpbmdsZSBjaGVjayBvZg0KPiA+IC0+dG90YWxfcGt0X3Np
emUgKEkgY2hlY2tlZDsgbXkgY29tcGlsZXIgZ2V0cyByaWQgb2YgdGhlIGxvb3ApLg0KPiANCj4g
VGhpcyBpcyBhbm90aGVyIGJ1ZyBpbiB0aGUgY29kZSBhY3R1YWxseTogdGhlIGNvZGUgYWNjZXNz
aW5nIHR4DQo+IGRlc2NyaXB0b3IgcmluZ3Mgc2hvdWxkIGJlIGRlY2xhcmVkIHZvbGF0aWxlIHNp
bmNlIHRoZXkgYXJlIHVwZGF0ZWQgYnkNCj4gdGhlIGRldmljZSB3aGljaCBpcyBub3QgdmlzaWJs
ZSB0byB0aGUgY29tcGlsZXIuICBDb21waWxlciB3b24ndA0KPiBvcHRpbWl6ZSAob3IgcmVvcmRl
cikgdm9sYXRpbGUgY29kZSAoYnkgInZvbGF0aWxlIGNvZGUiIEkgbWVhbiBjb2RlDQo+IHRoYXQg
aXMgYWNjZXNzaW5nIGRhdGEgbWFya2VkICJ2b2xhdGlsZSIpLg0KPiANCj4gPiBTbywgYXQgYSBt
aW5pbXVtLCB5b3Ugc2hvdWxkIGp1c3QgcmVtb3ZlIHRoZSBsb29wLiBCdXQgSSdtIG5vdCBzdXJl
IGlmDQo+ID4gdGhpcyAiY2hlY2siIGZ1bmN0aW9uIGhhcyBhbnkgdmFsdWUgYXQgYWxsLi4uDQo+
IA0KPiBJZiBSZWFsdGVrIGNhbid0IGZpeCB3aGF0IGFwcGVhcnMgdG8gYmUgYSBidWcgaW4gdGhl
IGZpcm13YXJlLCBJDQo+IHN1c3BlY3QgYSBwb2xsaW5nIGxvb3Agd2lsbCBiZSByZXF1aXJlZCAt
IGJ1dCBhZGQgYSAidWRlbGF5KDEpIiBpbiB0aGUNCj4gbG9vcC4NCj4gDQo+ID4NCj4gPiA+ICsN
Cj4gPiA+ICsgICAgIGlmIChpID49IDIwKQ0KPiA+ID4gKyAgICAgICAgICAgICBydHdfd2Fybihy
dHdkZXYsICJwY2kgYnVzIHRpbWVvdXQsIGRyb3AgcGFja2V0XG4iKTsNCj4gPg0KPiA+IC4uLkJU
VywgSSdtIHNlZWluZyB0aGlzIGdldCB0cmlnZ2VyZWQgcXVpdGUgYSBiaXQuDQo+ID4NCj4gPiBE
byB5b3UgaGF2ZSBzb21lIGtpbmQgb2YgbWVtb3J5IG1hcHBpbmcvb3JkZXJpbmcgaXNzdWUgb3Ig
c29tZXRoaW5nPyBJDQo+ID4gd291bGRuJ3QgdGhpbmsgeW91IHNob3VsZCBleHBlY3QgdG8ganVz
dCBkcm9wIHBhY2tldHMgb24gdGhlIGZsb29yIHNvDQo+ID4gb2Z0ZW4gbGlrZSB0aGlzLg0KPiAN
Cj4gQmFzZWQgb24gdGhlIGNvZGUgYWJvdmUsIEknbSB3aWxsaW5nIHRvIGJldCB5b3UgYXJlIGNv
cnJlY3QgdGhlIGRyaXZlcg0KPiBoYXMgbWVtb3J5IG9yZGVyaW5nIGlzc3Vlcy4gU2luY2UgdGhl
IGRlc2NyaXB0b3IgcmluZ3MgYXJlbid0IGRlY2xhcmVkDQo+IHZvbGF0aWxlLCB0aGUgY29tcGls
ZXIgaXMgZnJlZSB0byByZW9yZGVyIGFjY2Vzc2VzIHRvIHRob3NlIGZpZWxkcyBhcw0KPiBpdCBz
ZWVzIGZpdC4gVGhpcyBpcyBhIHJlYWwgcHJvYmxlbSBnaXZlbiB0aGUgZGV2aWNlIG1heSB1cGRh
dGUgdGhlDQo+IGZpZWxkcyBpbiB0aGUgZGlmZmVyZW50IG9yZGVyIHRoYW4gd2hhdCB0aGUgY29t
cGlsZXIgZW1pdHMgYXMgbWVtb3J5DQo+IGFjY2Vzc2VzLg0KPiANCg0KVGhpcyBpcyBmaXhlZCBp
biBQQVRDSCB2NS4gV2UgcmVzZXQgYW5kIHVzZSByeCB0YWcgdG8gc3luYyBkbWEuDQpTbyB0aGUg
cG9sbGluZyBjYW4gYmUgcmVtb3ZlZCBhbmQgdGhlIGJ1cyB0aW1lb3V0IGhhcyBub3QgaGFwcGVu
ZWQgYWdhaW4uDQoNClRoYW5rcw0KWWFuLUhzdWFuDQo=
