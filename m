Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:60801 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeGFEKA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 00:10:00 -0400
From: Pkshih <pkshih@realtek.com>
To: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "drake@endlessm.com" <drake@endlessm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
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
        Shaofu <shaofu@realtek.com>,
        "jian-hong@endlessm.com" <jian-hong@endlessm.com>
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
Date: Fri, 6 Jul 2018 03:34:30 +0000
Message-ID: <1530848057.2482.5.camel@realtek.com> (sfid-20180706_061020_543966_91620057)
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
         <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net>
         <20180704140933.3dk2ylbntltz6jqd@mwanda>
         <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net>
         <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com>
         <1530776154.4156.12.camel@realtek.com>
         <a54fe914-9402-a959-9ae5-540bfec64a14@lwfinger.net>
In-Reply-To: <a54fe914-9402-a959-9ae5-540bfec64a14@lwfinger.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE4LTA3LTA1IGF0IDEyOjA2IC0wNTAwLCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+
IE9uIDA3LzA1LzIwMTggMDI6MzYgQU0sIFBrc2hpaCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMTgt
MDctMDQgYXQgMTA6MzMgLTA1MDAsIERhbmllbCBEcmFrZSB3cm90ZToNCj4gPj4gT24gV2VkLCBK
dWwgNCwgMjAxOCBhdCAxMDoxMyBBTSwgTGFycnkgRmluZ2VyIDxMYXJyeS5GaW5nZXJAbHdmaW5n
ZXIubmV0PiB3cm90ZToNCj4gPj4+IFdlIHdpbGwgaGF2ZSB0byBhZ3JlZSB0byBkaXNhZ3JlZS4N
Cj4gPj4+DQo+ID4+PiBJIGhhdmUgbm8gaWRlYSB3aGF0IHRoZSB2ZW5kb3JzIGFyZSBkb2luZyB0
aGF0IGNhdXNlIHNvbWUgbW90aGVyYm9hcmRzIHRvDQo+ID4+PiBuZWVkIGEgZGlmZmVyZW50IGFz
cG0gdmFsdWUuIFdoYXQgSSBkbyBrbm93IGlzIHRoYXQgd2UgaGF2ZSBoYWQgdG8gbGl2ZSB3aXRo
DQo+ID4+PiB0aGUgaWRpb2N5IG9mIHNvbWUgdmVuZG9ycyBzYXZpbmcgYSBmZXcgcGVubmllcyBi
eSBvbmx5IGluY2x1ZGluZyBhIHNpbmdsZQ0KPiA+Pj4gYW50ZW5uYSwgcmF0aGVyIHRoYW4gdHdv
LCBhbmQgdGhlbiBtYWtpbmcgYSBwcm9ibGVtIGJ5IG1pc2NvZGluZyB0aGUgRUZVU0UNCj4gPj4+
IGJpdCB0aGF0IGluZGljYXRlcyB3aGljaCBjb25uZWN0b3IgaXMgYWN0dWFsbHkgaW4gdXNlLiBB
cyB3ZSBoYXZlIG5vIG1lYW5zDQo+ID4+PiB0aGF0IEkga25vdyBhYm91dCB0byBkZXRlY3Qgd2hp
Y2ggYm94ZXMgaGF2ZSB0aGUgcHJvYmxlbSwgYSBtb2R1bGUgcGFyYW1ldGVyDQo+ID4+PiB3YXMg
Y3JlYXRlZCwganVzdCBhcyBpbiB0aGlzIGNhc2UuDQo+ID4+Pg0KPiA+Pj4gSSBhZ3JlZSB0aGF0
IGRyaXZlcnMgc2hvdWxkIHdvcmsgIm91dCBvZiB0aGUgYm94IiwgYnV0IGZpbml0ZSByZXNvdXJj
ZXMgYW5kDQo+ID4+PiBsYWNrIG9mIHZlbmRvciBjb29wZXJhdGlvbiBtYWtlIHRoaXMgYSBnb2Fs
IHRoYXQgbWF5IG5vdCBiZSBhdHRhaW5hYmxlLg0KPiA+Pg0KPiA+PiBBcyB5b3UgdG91Y2hlZCBv
biwgdGhlIGlkZWFsIHNpdHVhdGlvbiBpcyB0aGF0IFJlYWx0ZWsgc29sdmUgdGhlDQo+ID4+IGlz
c3VlLiBQaW5nLUtlIFNoaWggaXMgb24gQ0MgYW5kIEkgYW0gYWRkaW5nIGEgZmV3IG1vcmUgY29u
dGFjdHMgZnJvbQ0KPiA+PiB0aGUgY29tbWl0IGxvZy4gVGhlIGNvbnRleHQgaXMgdGhhdCB0aGUg
cjg4MjIgZHJpdmVyIGZhaWxzIG9uIHNldmVyYWwNCj4gPj4gcGxhdGZvcm1zIHVubGVzcyBzZXR0
aW5nIGFzcG09MCAodGhlIGRlZmF1bHQgaXMgMSkuDQo+ID7CoA0KPiA+IEl0J3MgaGFyZCB0byBo
YXZlIGFsbCBsYXB0b3Agb3IgbW90aGVyYm9hcmRzIGFuZCBhbGwgcnRsODgyMmJlIG1vZHVsZXMg
aW4gbXkgc2lkZSwNCj4gPiBzbyB3aGF0IEkgY2FuIGRvIGlzIHRvIGFuYWx5emUgdGhlIGlzc3Vl
IHdoZW4gdXNlciBlbmNvdW50ZXJlZC4NCj4gPsKgDQo+ID4+DQo+ID4+IGh0dHBzOi8vZ2lzdC5n
aXRodWIuY29tL2RzZC8yMGMwNWYwYzZkNjZlZTJlZjliZmJiMTdmOTNmMThiYQ0KPiA+PiBodHRw
czovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTE5OTY1MQ0KPiA+Pg0KPiA+
Pg0KPiA+PiBJZiB3ZSBkb24ndCBnZXQgYSB0aW1lbHkgZml4IGZyb20gUmVhbHRlayB0aG91Z2gs
IEkgdGhpbmsgdGhlcmUgaXMgYQ0KPiA+PiBrZXkgZGlmZmVyZW5jZSBiZXR3ZWVuIHRoZSBhbnRl
bm5hIHNlbGVjdGlvbiBoZWFkYWNoZSBhbmQgdGhpcyBvbmUuIEluDQo+ID4+IHRoZSBhbnRlbm5h
IGNhc2UsIHRoZXJlIGlzbid0IGEgZ29vZCB2YWx1ZSB0aGF0IHlvdSBjYW4gc2V0IHRoYXQgd2ls
bA0KPiA+PiB3b3JrIG9uIGFsbCBzeXN0ZW1zLiBJZiB5b3UgY2hhbmdlIHRoZSBkZWZhdWx0IGJl
aGF2aW91ciB5b3Ugd2lsbA0KPiA+PiBzb2x2ZSB0aGUgaXNzdWUgZm9yIHNvbWUgdXNlcnMgd2hp
bGUgc2ltdWx0YW5vdXNseSBpbnRyb2R1Y2luZyB0aGUNCj4gPj4gcHJvYmxlbSBvbiBvdGhlciBz
eXN0ZW1zIHRoYXQgd2VyZSBwcmV2aW91c2x5IGZpbmUuDQo+ID4+DQo+ID4+IEhvd2V2ZXIgaW4g
dGhpcyBjYXNlLCBpdCdzIGhpZ2hseSBsaWtlbHkgdGhhdCBzZXR0aW5nIGFzcG09MCAob2ZmKSBi
eQ0KPiA+PiBkZWZhdWx0IHdvdWxkIHdvcmsgZm9yIGV2ZXJ5b25lLiBJdCBoYXMgdGhlIGRpc2Fk
dmFudGFnZSBvZiB1c2luZyBhDQo+ID4+IGJpdCBtb3JlIHBvd2VyLCBidXQgZXNwZWNpYWxseSB3
aXRoIHRoZSBpbmRpY2F0aW9ucyB0aGF0IHRoaXMgaXNzdWUNCj4gPj4gYWZmZWN0cyBhIHNpZ25p
ZmljYW50IG51bWJlciBvZiBzeXN0ZW1zLCBJIHRoaW5rIHRoYXQgaGF2aW5nIHRoZQ0KPiA+PiBk
cml2ZXIgd29ya2luZyBvdXQgb2YgdGhlIGJveCBldmVyeXdoZXJlIGlzIG1vcmUgaW1wb3J0YW50
LiBUaGUgbW9kdWxlDQo+ID4+IHBhcmFtZXRlciBjYW4gYmUgbGVmdCBpbiBwbGFjZSBzbyB0aGF0
IHVuYWZmZWN0ZWQgdXNlcnMgdGhhdCB3YW50IHRvDQo+ID4+IHNhdmUgcG93ZXIgY2FuIHNldCBh
c3BtPTEuDQo+ID4+DQo+ID7CoA0KPiA+IEkgdGhpbmsgdGhpcyBpc3N1ZSBtYXkgYmUgZHVlIHRv
IEwxIGxhdGVuY3ksIHNvIGJlbG93IHBhdGNoIHdvdWxkIGJlDQo+ID4gaGVscGZ1bCBidXQgbm90
IHN1cmUgYmVjYXVzZSBJIGRvbid0IGhhdmUgdGhlIHNhbWUgbGFwdG9wLg0KPiA+IElzIHRoZXJl
IGFueW9uZSBjYW4gaGVscCB0byB0ZXN0Pw0KPiA+wqANCj4gPsKgDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy9ydGx3aWZpL3J0bDg4MjJiZS9ody5jIGIvZHJpdmVycy9zdGFnaW5n
L3J0bHdpZmkvcnRsODgyMmJlL2h3LmMNCj4gPiBpbmRleCA3OTQ3ZWRiMjM5YTEuLjg4YmE1YjJm
ZWE2YSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3N0YWdpbmcvcnRsd2lmaS9ydGw4ODIyYmUv
aHcuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc3RhZ2luZy9ydGx3aWZpL3J0bDg4MjJiZS9ody5jDQo+
ID4gQEAgLTgwMyw3ICs4MDMsNyBAQCBzdGF0aWMgdm9pZCBfcnRsODgyMmJlX2VuYWJsZV9hc3Bt
X2JhY2tfZG9vcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodykNCj4gPsKgwqDCoAkJcmV0dXJuOw0K
PiA+wqDCoMKgDQo+ID7CoMKgwqAJcGNpX3JlYWRfY29uZmlnX2J5dGUocnRscGNpLT5wZGV2LCAw
eDcwZiwgJnRtcCk7DQo+ID4gLQlwY2lfd3JpdGVfY29uZmlnX2J5dGUocnRscGNpLT5wZGV2LCAw
eDcwZiwgdG1wIHwgQklUKDcpKTsNCj4gPiArCXBjaV93cml0ZV9jb25maWdfYnl0ZShydGxwY2kt
PnBkZXYsIDB4NzBmLCB0bXAgfCBBU1BNX0wxX0xBVEVOQ1kgPDwgMyk7DQo+IA0KPiBUaGlzIHBh
dGNoIGxvc2VzIHRoZSBCSVQoNykuIERpZCB5b3UgcmVhbGx5IG1lYW4gdG8gZG8gdGhhdD8NCj4g
DQo+IEkgbm93IGFncmVlIHRoYXQgdGhpcyBpcyBhIGJ1Zy4gQSBzaW1pbGFyIHByb2JsZW0gaGFk
IGJlZW4gZm91bmQgaW4gYSBmZXcgYm94ZXPCoA0KPiB3aXRoIFJUTDg3MjNCRSBvciBSVEw4ODIx
QUUgY2FyZHMsIGJ1dCB0aGF0IGl0IG1pZ2h0IGFwcGx5IGhlcmUgY29tcGxldGVsecKgDQo+IHNs
aXBwZWQgdGhyb3VnaCB0aGUgZXZlciBsYXJnZXIgY3JhY2tzIGluIG15IG1pbmQuDQo+IA0KDQpZ
ZXMsIEkgcmVtb3ZlIEJJVCg3KSBpbnRlbnRpb25hbGx5LCBiZWNhdXNlIHRoaXMgaXMgZGVmaW5l
ZCBhcyByZXNlcnZlZCBiaXQgaW4gcnRsODgyMmJlLg0KRm9yIHRoZSBvbGRlciBjaGlwcywgSSBu
ZWVkIHRvIGNoZWNrIHdpdGggbXkgY29sbGVhZ3Vlcy4NCg0KUmVnYXJkcywNClBLDQo=
