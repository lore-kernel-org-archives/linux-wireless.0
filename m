Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:37165 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbeGEHgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 03:36:54 -0400
From: Pkshih <pkshih@realtek.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "drake@endlessm.com" <drake@endlessm.com>
CC: Shaofu <shaofu@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Birming Chiu <birming@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "frank@generalsoftwareinc.com" <frank@generalsoftwareinc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Steven Ting <steventing@realtek.com>,
        Tony Chuang <yhchuang@realtek.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "jian-hong@endlessm.com" <jian-hong@endlessm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
Date: Thu, 5 Jul 2018 07:36:02 +0000
Message-ID: <1530776154.4156.12.camel@realtek.com> (sfid-20180705_093710_967872_59B2C2B3)
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
         <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net>
         <20180704140933.3dk2ylbntltz6jqd@mwanda>
         <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net>
         <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com>
In-Reply-To: <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE4LTA3LTA0IGF0IDEwOjMzIC0wNTAwLCBEYW5pZWwgRHJha2Ugd3JvdGU6DQo+
IE9uIFdlZCwgSnVsIDQsIDIwMTggYXQgMTA6MTMgQU0sIExhcnJ5IEZpbmdlciA8TGFycnkuRmlu
Z2VyQGx3ZmluZ2VyLm5ldD4gd3JvdGU6DQo+ID4gV2Ugd2lsbCBoYXZlIHRvIGFncmVlIHRvIGRp
c2FncmVlLg0KPiA+DQo+ID4gSSBoYXZlIG5vIGlkZWEgd2hhdCB0aGUgdmVuZG9ycyBhcmUgZG9p
bmcgdGhhdCBjYXVzZSBzb21lIG1vdGhlcmJvYXJkcyB0bw0KPiA+IG5lZWQgYSBkaWZmZXJlbnQg
YXNwbSB2YWx1ZS4gV2hhdCBJIGRvIGtub3cgaXMgdGhhdCB3ZSBoYXZlIGhhZCB0byBsaXZlIHdp
dGgNCj4gPiB0aGUgaWRpb2N5IG9mIHNvbWUgdmVuZG9ycyBzYXZpbmcgYSBmZXcgcGVubmllcyBi
eSBvbmx5IGluY2x1ZGluZyBhIHNpbmdsZQ0KPiA+IGFudGVubmEsIHJhdGhlciB0aGFuIHR3bywg
YW5kIHRoZW4gbWFraW5nIGEgcHJvYmxlbSBieSBtaXNjb2RpbmcgdGhlIEVGVVNFDQo+ID4gYml0
IHRoYXQgaW5kaWNhdGVzIHdoaWNoIGNvbm5lY3RvciBpcyBhY3R1YWxseSBpbiB1c2UuIEFzIHdl
IGhhdmUgbm8gbWVhbnMNCj4gPiB0aGF0IEkga25vdyBhYm91dCB0byBkZXRlY3Qgd2hpY2ggYm94
ZXMgaGF2ZSB0aGUgcHJvYmxlbSwgYSBtb2R1bGUgcGFyYW1ldGVyDQo+ID4gd2FzIGNyZWF0ZWQs
IGp1c3QgYXMgaW4gdGhpcyBjYXNlLg0KPiA+DQo+ID4gSSBhZ3JlZSB0aGF0IGRyaXZlcnMgc2hv
dWxkIHdvcmsgIm91dCBvZiB0aGUgYm94IiwgYnV0IGZpbml0ZSByZXNvdXJjZXMgYW5kDQo+ID4g
bGFjayBvZiB2ZW5kb3IgY29vcGVyYXRpb24gbWFrZSB0aGlzIGEgZ29hbCB0aGF0IG1heSBub3Qg
YmUgYXR0YWluYWJsZS4NCj4gDQo+IEFzIHlvdSB0b3VjaGVkIG9uLCB0aGUgaWRlYWwgc2l0dWF0
aW9uIGlzIHRoYXQgUmVhbHRlayBzb2x2ZSB0aGUNCj4gaXNzdWUuIFBpbmctS2UgU2hpaCBpcyBv
biBDQyBhbmQgSSBhbSBhZGRpbmcgYSBmZXcgbW9yZSBjb250YWN0cyBmcm9tDQo+IHRoZSBjb21t
aXQgbG9nLiBUaGUgY29udGV4dCBpcyB0aGF0IHRoZSByODgyMiBkcml2ZXIgZmFpbHMgb24gc2V2
ZXJhbA0KPiBwbGF0Zm9ybXMgdW5sZXNzIHNldHRpbmcgYXNwbT0wICh0aGUgZGVmYXVsdCBpcyAx
KS4NCg0KSXQncyBoYXJkIHRvIGhhdmUgYWxsIGxhcHRvcCBvciBtb3RoZXJib2FyZHMgYW5kIGFs
bCBydGw4ODIyYmUgbW9kdWxlcyBpbiBteSBzaWRlLA0Kc28gd2hhdCBJIGNhbiBkbyBpcyB0byBh
bmFseXplIHRoZSBpc3N1ZSB3aGVuIHVzZXIgZW5jb3VudGVyZWQuDQoNCj4gDQo+IGh0dHBzOi8v
Z2lzdC5naXRodWIuY29tL2RzZC8yMGMwNWYwYzZkNjZlZTJlZjliZmJiMTdmOTNmMThiYQ0KPiBo
dHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTE5OTY1MQ0KPiANCj4g
DQo+IElmIHdlIGRvbid0IGdldCBhIHRpbWVseSBmaXggZnJvbSBSZWFsdGVrIHRob3VnaCwgSSB0
aGluayB0aGVyZSBpcyBhDQo+IGtleSBkaWZmZXJlbmNlIGJldHdlZW4gdGhlIGFudGVubmEgc2Vs
ZWN0aW9uIGhlYWRhY2hlIGFuZCB0aGlzIG9uZS4gSW4NCj4gdGhlIGFudGVubmEgY2FzZSwgdGhl
cmUgaXNuJ3QgYSBnb29kIHZhbHVlIHRoYXQgeW91IGNhbiBzZXQgdGhhdCB3aWxsDQo+IHdvcmsg
b24gYWxsIHN5c3RlbXMuIElmIHlvdSBjaGFuZ2UgdGhlIGRlZmF1bHQgYmVoYXZpb3VyIHlvdSB3
aWxsDQo+IHNvbHZlIHRoZSBpc3N1ZSBmb3Igc29tZSB1c2VycyB3aGlsZSBzaW11bHRhbm91c2x5
IGludHJvZHVjaW5nIHRoZQ0KPiBwcm9ibGVtIG9uIG90aGVyIHN5c3RlbXMgdGhhdCB3ZXJlIHBy
ZXZpb3VzbHkgZmluZS4NCj4gDQo+IEhvd2V2ZXIgaW4gdGhpcyBjYXNlLCBpdCdzIGhpZ2hseSBs
aWtlbHkgdGhhdCBzZXR0aW5nIGFzcG09MCAob2ZmKSBieQ0KPiBkZWZhdWx0IHdvdWxkIHdvcmsg
Zm9yIGV2ZXJ5b25lLiBJdCBoYXMgdGhlIGRpc2FkdmFudGFnZSBvZiB1c2luZyBhDQo+IGJpdCBt
b3JlIHBvd2VyLCBidXQgZXNwZWNpYWxseSB3aXRoIHRoZSBpbmRpY2F0aW9ucyB0aGF0IHRoaXMg
aXNzdWUNCj4gYWZmZWN0cyBhIHNpZ25pZmljYW50IG51bWJlciBvZiBzeXN0ZW1zLCBJIHRoaW5r
IHRoYXQgaGF2aW5nIHRoZQ0KPiBkcml2ZXIgd29ya2luZyBvdXQgb2YgdGhlIGJveCBldmVyeXdo
ZXJlIGlzIG1vcmUgaW1wb3J0YW50LiBUaGUgbW9kdWxlDQo+IHBhcmFtZXRlciBjYW4gYmUgbGVm
dCBpbiBwbGFjZSBzbyB0aGF0IHVuYWZmZWN0ZWQgdXNlcnMgdGhhdCB3YW50IHRvDQo+IHNhdmUg
cG93ZXIgY2FuIHNldCBhc3BtPTEuDQo+IA0KDQpJIHRoaW5rIHRoaXMgaXNzdWUgbWF5IGJlIGR1
ZSB0byBMMSBsYXRlbmN5LCBzbyBiZWxvdyBwYXRjaCB3b3VsZCBiZQ0KaGVscGZ1bCBidXQgbm90
IHN1cmUgYmVjYXVzZSBJIGRvbid0IGhhdmUgdGhlIHNhbWUgbGFwdG9wLg0KSXMgdGhlcmUgYW55
b25lIGNhbiBoZWxwIHRvIHRlc3Q/DQoNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9y
dGx3aWZpL3J0bDg4MjJiZS9ody5jIGIvZHJpdmVycy9zdGFnaW5nL3J0bHdpZmkvcnRsODgyMmJl
L2h3LmMNCmluZGV4IDc5NDdlZGIyMzlhMS4uODhiYTViMmZlYTZhIDEwMDY0NA0KLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3J0bHdpZmkvcnRsODgyMmJlL2h3LmMNCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy9ydGx3aWZpL3J0bDg4MjJiZS9ody5jDQpAQCAtODAzLDcgKzgwMyw3IEBAIHN0YXRpYyB2b2lk
IF9ydGw4ODIyYmVfZW5hYmxlX2FzcG1fYmFja19kb29yKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
KQ0KwqAJCXJldHVybjsNCsKgDQrCoAlwY2lfcmVhZF9jb25maWdfYnl0ZShydGxwY2ktPnBkZXYs
IDB4NzBmLCAmdG1wKTsNCi0JcGNpX3dyaXRlX2NvbmZpZ19ieXRlKHJ0bHBjaS0+cGRldiwgMHg3
MGYsIHRtcCB8IEJJVCg3KSk7DQorCXBjaV93cml0ZV9jb25maWdfYnl0ZShydGxwY2ktPnBkZXYs
IDB4NzBmLCB0bXAgfCBBU1BNX0wxX0xBVEVOQ1kgPDwgMyk7DQrCoA0KwqAJcGNpX3JlYWRfY29u
ZmlnX2J5dGUocnRscGNpLT5wZGV2LCAweDcxOSwgJnRtcCk7DQrCoAlwY2lfd3JpdGVfY29uZmln
X2J5dGUocnRscGNpLT5wZGV2LCAweDcxOSwgdG1wIHwgQklUKDMpIHwgQklUKDQpKTsNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvcnRsd2lmaS93aWZpLmggYi9kcml2ZXJzL3N0YWdpbmcv
cnRsd2lmaS93aWZpLmgNCmluZGV4IDAxMmZiNjE4ODQwYi4uYTQ1ZjBlYjY5ZDNmIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3J0bHdpZmkvd2lmaS5oDQorKysgYi9kcml2ZXJzL3N0YWdp
bmcvcnRsd2lmaS93aWZpLmgNCkBAIC04OCw2ICs4OCw3IEBADQrCoCNkZWZpbmUgUlRMX1VTQl9N
QVhfUlhfQ09VTlQJCQkxMDANCsKgI2RlZmluZSBRQlNTX0xPQURfU0laRQkJCQk1DQrCoCNkZWZp
bmUgTUFYX1dNTUVMRV9MRU5HVEgJCQk2NA0KKyNkZWZpbmUgQVNQTV9MMV9MQVRFTkNZCQkJCTcN
CsKgDQrCoCNkZWZpbmUgVE9UQUxfQ0FNX0VOVFJZCQkJCTMyDQrCoA0KDQotLS0NClBLDQoNCg==
