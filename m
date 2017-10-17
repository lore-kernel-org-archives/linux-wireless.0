Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:37127 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbdJQBqO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 21:46:14 -0400
From: Pkshih <pkshih@realtek.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?big5?B?svir26vF?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Two rtlwifi drivers?
Date: Tue, 17 Oct 2017 01:45:45 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D105821780@RTITMBSV07.realtek.com.tw> (sfid-20171017_034629_561006_3E190A1C)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>       <20171011131310.GF32250@kroah.com>
        <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>       <20171012103450.GA24647@kroah.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
 <87bml7mdlj.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87bml7mdlj.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FsbGUgVmFsbyBbbWFp
bHRvOmt2YWxvQGNvZGVhdXJvcmEub3JnXQ0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgMTYsIDIw
MTcgOToyMyBQTQ0KPiBUbzogUGtzaGloDQo+IENjOiBMYXJyeSBGaW5nZXI7IEdyZWcgS3JvYWgt
SGFydG1hbjsgRGFuIENhcnBlbnRlcjsgsvir26vFOyBKb2hhbm5lcyBCZXJnOyBTb3VwdGljayBK
b2FyZGVyOw0KPiBkZXZlbEBkcml2ZXJkZXYub3N1b3NsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdl
ci5rZXJuZWwub3JnOyBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFJlOiBUd28gcnRsd2lmaSBkcml2ZXJzPw0KPiANCj4gSGkgUEssDQo+IA0KPiB5b3UgZ290IGdv
b2QgYW5zd2VycyBhbHJlYWR5IHNvIG9ubHkgc2hvcnQgcmVwbHkgZnJvbSBtZToNCj4gDQo+IFBr
c2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiB3cml0ZXM6DQo+IA0KPiA+IDMpIENvbWluZyBkcml2
ZXJzIC0tIHJ0bDg3MjNkZSBhbmQgcnRsODgyMWNlDQo+ID4gICAgV2UncmUgZGV2ZWxvcGluZyB0
aGUgdHdvIGRyaXZlcnMsIGFuZCBydGw4NzIzZGUgYW5kIHJ0bDg4MjFjZSB3aWxsDQo+ID4gICAg
YmUgcmVhZHkgb24gMjAxN1E0IGFuZCAyMDE4UTEgcmVzcGVjdGl2ZWx5LiBUaGUgZHJpdmVycyBh
cmUgYmFzZWQgb24NCj4gPiAgICBydGw4ODIyYmUgdGhhdCBpbiBzdGFnaW5nIG5vdywgc28gdGhl
IGxpbmUgb2YgY29kZSB3aWxsIGJlIGZld2VyLg0KPiA+ICAgIFRoZSBuZXcgZmlsZXMgd2lsbCBi
ZSBhIG5ldyBJQyBmb2xkZXIgYW5kIElDIHN1cHBvcnRlZCBmaWxlcyBvZg0KPiA+ICAgIHRocmVl
IG1vZHVsZXMgdGhhdCBidGNvZXhpc3QsIHBoeWRtIGFuZCBoYWxtYWMuIENvdWxkIEkgc3VibWl0
DQo+ID4gICAgdGhlbSB0byB3aXJsZXNzIHRyZWUgd2hlbiB0aGV5J3JlIHJlYWR5Pw0KPiANCj4g
TXkgcmVjb21tZW5kYXRpb24gaXMgdG8gYXZvaWQgYWNjdW11bGF0aW5nIHBhdGNoZXMgYXQgYWxs
IGNvc3QgYW5kIHN0YXJ0DQo+IHN1Ym1pdHRpbmcgdGhlbSBhcyBzb29uIGFzIHlvdSBjYW4uIFRo
aXMgd2F5IHlvdSBnZXQgcGF0Y2hlcyBjb21taXR0ZWQNCj4gbXVjaCBtb3JlIHNtb290aGVyLiBT
byBkbyBub3Qgd2FpdCB1bnRpbCBfYWxsXyBwYXRjaGVzIGFyZSByZWFkeSwNCj4gaW5zdGVhZCBz
dGFydCBzdWJtaXR0aW5nIHBhdGNoZXMgYXMgc29vbiBhcyB5b3UgaGF2ZSBfc29tZV8gcGF0Y2hl
cw0KPiByZWFkeS4gSW4gb3RoZXIgd29yZHMsIGtlZXAgdGhlIGRlbHRhIGJldHdlZW4gbWFpbmxp
bmUgYW5kIHlvdXINCj4gbm90LXlldC1zdWJtaXR0ZWQgcGF0Y2hlcyBhcyBzbWFsbCBhcyBwb3Nz
aWJsZS4NCj4gDQo+IEFuZCB0aGUgcGF0Y2hlcyBkb24ndCBuZWVkIHRvIGJlIGJ1ZyBmcmVlIGFz
IHlvdSBjYW4gYWx3YXlzIGZpeCBidWdzDQo+IGxhdGVyLiBKdXN0IG1lbnRpb24gaW4gdGhlIGNv
bW1pdCBsb2dzIHRoYXQgdGhpcyBpcyBwcmVwYXJhdGlvbiBmb3Igc29tZQ0KPiBuZXcgZmVhdHVy
ZSBhbmQgbm90IGZ1bGx5IHRlc3RlZCB5ZXQuIFdlIGRvIHRoYXQgYWxsIHRoZSB0aW1lLCBmb3IN
Cj4gZXhhbXBsZSBJbnRlbCdzIGl3bHdpZmkgaGFzIHN1cHBvcnQgZm9yIGhhcmR3YXJlIHdoaWNo
IGhhdmUgbm90IHJlYWNoZWQNCj4gY3VzdG9tZXJzIHlldC4NCj4gDQoNClRoYW5rcyBmb3IgeW91
ciBhbnN3ZXIuIEknbGwgc3VibWl0IHBhdGNoZXMgd2hlbiB0aGUgZHJpdmVycyBhcmUgcmVhZHkg
YW5kDQpzdGFibGUuIEkgaGF2ZSBhbm90aGVyIHF1ZXN0aW9uIGFib3V0IHRoZSBydWxlcyBvZiBu
ZXcgZmlsZXMuIElmIEkgd2FudCB0bw0KYWRkIHNvbWUgbmV3IGZpbGVzLCBjb3VsZCBJIHNlbmQg
YSBiaWcgcGF0Y2ggd2l0aCBhbGwgbmV3IGZpbGVzPyBJcyB0aGVyZQ0KYW55IGxpbWl0PyANCg0K
VGhhbmtzDQpQSw0KDQoNCg==
