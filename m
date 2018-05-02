Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:55726 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbeEBF65 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 01:58:57 -0400
From: Pkshih <pkshih@realtek.com>
To: "jprvita@gmail.com" <jprvita@gmail.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jprvita@endlessm.com" <jprvita@endlessm.com>,
        Birming Chiu <birming@realtek.com>,
        "drake@endlessm.com" <drake@endlessm.com>,
        Chaoming_Li <chaoming_li@realsil.com.cn>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "derosier@gmail.com" <derosier@gmail.com>,
        Steven Ting <steventing@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Shaofu <shaofu@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RTL8723BE performance regression
Date: Wed, 2 May 2018 05:58:42 +0000
Message-ID: <1525240713.3735.3.camel@realtek.com> (sfid-20180502_080121_117685_CB397C47)
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
         <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net>
         <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com>
         <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net>
         <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
         <5B2DA6FDDF928F4E855344EE0A5C39D13BEC14C0@RTITMBSV07.realtek.com.tw>
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BEC14C0@RTITMBSV07.realtek.com.tw>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gV2VkLCAyMDE4LTA1LTAyIGF0IDA1OjQ0ICswMDAwLCBQa3NoaWggd3JvdGU6DQo+IA0KPiA+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogSm/Do28gUGF1bG8gUmVjaGkg
Vml0YSBbbWFpbHRvOmpwcnZpdGFAZ21haWwuY29tXQ0KPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWF5
IDAyLCAyMDE4IDY6NDEgQU0NCj4gPiBUbzogTGFycnkgRmluZ2VyDQo+ID4gQ2M6IFN0ZXZlIGRl
Um9zaWVyOyDojorlvaXlrqM7IFBrc2hpaDsgQmlybWluZyBDaGl1OyBTaGFvZnU7IFN0ZXZlbiBU
aW5nOyBDaGFvbWluZ19MaTsgS2FsbGUgVmFsbzsNCj4gPiBsaW51eC13aXJlbGVzczsgTmV0d29y
ayBEZXZlbG9wbWVudDsgTEtNTDsgRGFuaWVsIERyYWtlOyBKb8OjbyBQYXVsbyBSZWNoaSBWaXRh
OyBsaW51eEBlbmRsZXNzbS5jDQo+IG9tDQo+ID4gU3ViamVjdDogUmU6IFJUTDg3MjNCRSBwZXJm
b3JtYW5jZSByZWdyZXNzaW9uDQo+ID7CoA0KPiA+IE9uIFR1ZSwgQXByIDMsIDIwMTggYXQgNzo1
MSBQTSwgTGFycnkgRmluZ2VyIDxMYXJyeS5GaW5nZXJAbHdmaW5nZXIubmV0PiB3cm90ZToNCj4g
PiA+IE9uIDA0LzAzLzIwMTggMDk6MzcgUE0sIEpvw6NvIFBhdWxvIFJlY2hpIFZpdGEgd3JvdGU6
DQo+ID4gPj4NCj4gPiA+PiBPbiBUdWUsIEFwciAzLCAyMDE4IGF0IDc6MjggUE0sIExhcnJ5IEZp
bmdlciA8TGFycnkuRmluZ2VyQGx3ZmluZ2VyLm5ldD4NCj4gPiA+PiB3cm90ZToNCj4gPiA+Pg0K
PiA+ID4+ICguLi4pDQo+ID4gPj4NCj4gPiA+Pj4gQXMgdGhlIGFudGVubmEgc2VsZWN0aW9uIGNv
ZGUgY2hhbmdlcyBhZmZlY3RlZCB5b3VyIGZpcnN0IGJpc2VjdGlvbiwgZG8NCj4gPiA+Pj4geW91
DQo+ID4gPj4+IGhhdmUgb25lIG9mIHRob3NlIEhQIGxhcHRvcHMgd2l0aCBvbmx5IG9uZSBhbnRl
bm5hIGFuZCB0aGUgaW5jb3JyZWN0DQo+ID4gPj4+IGNvZGluZw0KPiA+ID4+PiBpbiB0aGUgRlVT
RT8NCj4gPiA+Pg0KPiA+ID4+DQo+ID4gPj4gWWVzLCB0aGF0IGlzIHdoeSBJJ3ZlIGJlZW4gcGFz
c2luZyBhbnRfc2VsPTEgZHVyaW5nIG15IHRlc3RzIC0tIHRoaXMNCj4gPiA+PiB3YXMgbmVlZGVk
IHRvIGFjaGlldmUgYSBnb29kIHBlcmZvcm1hbmNlIGluIHRoZSBwYXN0LCBiZWZvcmUgdGhpcw0K
PiA+ID4+IHJlZ3Jlc3Npb24uIEkndmUgYWxzbyBvcGVuZWQgdGhlIGxhcHRvcCBjaGFzc2lzIGFu
ZCBjb25maXJtZWQgdGhlDQo+ID4gPj4gYW50ZW5uYSBjYWJsZSBpcyBwbHVnZ2VkIHRvIHRoZSBj
b25uZWN0b3IgbGFiZWxlZCB3aXRoICIxIiBvbiB0aGUNCj4gPiA+PiBjYXJkLg0KPiA+ID4+DQo+
ID4gPj4+IElmIHNvLCBwbGVhc2UgbWFrZSBzdXJlIHRoYXQgeW91IHN0aWxsIGhhdmUgdGhlIHNh
bWUgc2lnbmFsDQo+ID4gPj4+IHN0cmVuZ3RoIGZvciBnb29kIGFuZCBiYWQgY2FzZXMuIEkgaGF2
ZSB0cmllZCB0byBrZWVwIHRoZSBkcml2ZXIgYW5kIHRoZQ0KPiA+ID4+PiBidGNvZXggY29kZSBp
biBzeW5jLCBidXQgdGhlcmUgbWF5IGJlIHNvbWUgY29tYmluYXRpb25zIG9mIGFudGVubmENCj4g
PiA+Pj4gY29uZmlndXJhdGlvbiBhbmQgRlVTRSBjb250ZW50cyB0aGF0IGNhdXNlIHRoZSBjb2Rl
IHRvIGZhaWwuDQo+ID4gPj4+DQo+ID4gPj4NCj4gPiA+PiBXaGF0IGlzIHRoZSByZWNvbW1lbmRl
ZCB3YXkgdG8gbW9uaXRvciB0aGUgc2lnbmFsIHN0cmVuZ3RoPw0KPiA+ID4NCj4gPiA+DQo+ID4g
PiBUaGUgYnRjb2V4IGNvZGUgaXMgZGV2ZWxvcGVkIGZvciBtdWx0aXBsZSBwbGF0Zm9ybXMgYnkg
YSBkaWZmZXJlbnQgZ3JvdXANCj4gPiA+IHRoYW4gdGhlIExpbnV4IGRyaXZlci4gSSB0aGluayB0
aGV5IG1hZGUgYSBjaGFuZ2UgdGhhdCBjYXVzZWQgYW50X3NlbCB0bw0KPiA+ID4gc3dpdGNoIGZy
b20gMSB0byAyLiBBdCBsZWFzdCBudW1lcm91cyBjb21tZW50cyBhdA0KPiA+ID4gZ2l0aHViLmNv
bS9sd2Zpbmdlci9ydGx3aWZpX25ldyBjbGFpbWVkIHRoZXkgbmVlZGVkIHRvIG1ha2UgdGhhdCBj
aGFuZ2UuDQo+ID4gPg0KPiA+ID4gTWh5IHJlY29tbWVuZGVkIG1ldGhvZCBpcyB0byB2ZXJpZnkg
dGhlIHdpZmkgZGV2aWNlIG5hbWUgd2l0aCAiaXcgZGV2Ii4gVGhlbg0KPiA+ID4gdXNpbmcgdGhh
dCBkZXZpY2UNCj4gPiA+DQo+ID4gPiBzdWRvIGl3IGRldiA8ZGV2X25hbWU+IHNjYW4gfCBlZ3Jl
cCAiU1NJRHxzaWduYWwiDQo+ID4gPg0KPiA+wqANCj4gPiBJIGhhdmUgY29uZmlybWVkIHRoYXQg
dGhlIHBlcmZvcm1hbmNlIHJlZ3Jlc3Npb24gaXMgaW5kZWVkIHRpZWQgdG8NCj4gPiBzaWduYWwg
c3RyZW5ndGg6IG9uIHRoZSBnb29kIGNhc2VzIHNpZ25hbCB3YXMgYmV0d2VlbiAtMTYgYW5kIC04
IGRCbSwNCj4gPiB3aGVyZWFzIGluIGJhZCBjYXNlcyBzaWduYWwgd2FzIGFsd2F5cyBiZXR3ZWVu
IC01MCB0byAtIDQwIGRCbS4gSSd2ZQ0KPiA+IGFsc28gc3dpdGNoZWQgdG8gdGVzdGluZyBiYW5k
d2lkdGggaW4gY29udHJvbGxlZCBMQU4gZW52aXJvbm1lbnQgdXNpbmcNCj4gPiBpcGVyZjMsIGFz
IHN1Z2dlc3RlZCBieSBTdGV2ZSBkZVJvc2llciwgd2l0aCB0aGUgRFVUIGJlaW5nIHRoZSBvbmx5
DQo+ID4gbWFjaGluZSBjb25uZWN0ZWQgdG8gdGhlIDIuNCBHSHogcmFkaW8gYW5kIHRoZSBtYWNo
aW5lIHJ1bm5pbmcgdGhlDQo+ID4gaXBlcmYzIHNlcnZlciBjb25uZWN0ZWQgdmlhIGV0aGVybmV0
Lg0KPiA+wqANCj4gDQo+IFdlIGhhdmUgbmV3IGV4cGVyaW1lbnRhbCByZXN1bHRzIGluIGNvbW1p
dCBhZjhhNDFjY2NmOGY0NiAoInJ0bHdpZmk6IGNsZWFudXDCoA0KPiA4NzIzYmUgYW50X3NlbCBk
ZWZpbml0aW9uIikuIFlvdSBjYW4gdXNlIHRoZSBhYm92ZSBjb21taXQgYW5kIGRvIHRoZSBzYW1l
wqANCj4gZXhwZXJpbWVudHMgKHdpdGggYW50X3NlbD0wLCAxIGFuZCAyKSBpbiB5b3VyIHNpZGUs
IGFuZCB0aGVuIHNoYXJlIHlvdXIgcmVzdWx0cy4NCj4gU2luY2UgcGVyZm9ybWFuY2UgaXMgdGll
ZCB0byBzaWduYWwgc3RyZW5ndGgsIHlvdSBjYW4gb25seSBzaGFyZSBzaWduYWwgc3RyZW5ndGgu
DQo+IA0KDQpQbGVhc2UgcGF5IGF0dGVudGlvbiB0byBjb2xkIHJlYm9vdCBvbmNlIGFudF9zZWwg
aXMgY2hhbmdlZC4NCg0K
