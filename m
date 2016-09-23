Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40869 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759487AbcIWWS6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 18:18:58 -0400
From: "Pedersen, Thomas" <twp@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k mesh + ap + encryption?
Date: Fri, 23 Sep 2016 22:18:49 +0000
Message-ID: <1474669037.16013.9.camel@qca.qualcomm.com> (sfid-20160924_001902_194728_A52BB244)
References: <2661831.slnB0LOeVt@prime> <3247815.ey5ZWkP5uX@prime>
         <1473789271.27738.4.camel@qca.qualcomm.com> <5898628.mmcCycDigQ@prime>
In-Reply-To: <5898628.mmcCycDigQ@prime>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gTW9uLCAyMDE2LTA5LTE5IGF0IDA4OjQzICswMjAwLCBTaW1vbiBXdW5kZXJsaWNoIHdyb3Rl
Og0KPiBPbiBUdWVzZGF5LCBTZXB0ZW1iZXIgMTMsIDIwMTYgNTo1NDozOCBQTSBDRVNUIFBlZGVy
c2VuLCBUaG9tYXMgd3JvdGU6DQo+ID4gT24gVHVlLCAyMDE2LTA5LTEzIGF0IDE0OjMwICswMjAw
LCBTaW1vbiBXdW5kZXJsaWNoIHdyb3RlOg0KPiA+IA0KPiA+ID4gWy4uLl0NCj4gPiA+DQo+ID4g
PiBUaGFua3MgZm9yIHRoZSBjbGFyaWZpY2F0aW9uLiBXZSB3aWxsIHRoZW4gc3RpY2sgdG8gdGhl
IDcwJ3MgYnJhbmNoDQo+ID4gPiB0aGVuLg0KPiA+ID4gDQo+ID4gPiBEb2VzIGFueW9uZSBoYXZl
IHBvaW50ZXJzIGZvciB0aGUgb3RoZXIgcXVlc3Rpb25zPyA6KSBJIHdvdWxkIGJlbGlldmUNCj4g
PiA+IGhhdCBtYW55IA0KPiA+ID4gcGVvcGxlIHdvdWxkIGJlIGludGVyZXN0ZWQgaW4gcnVubmlu
ZyBBUCArIE1lc2ggZW5jcnlwdGVkIGF0IHRoZSBzYW1lDQo+ID4gPiB0aW1lIChhdCANCj4gPiA+
IGxlYXN0IGluIHRoZSBvcGVuIHNvdXJjZSBjb21tdW5pdHkgLi4uKS4NCj4gPiANCj4gPiANCj4g
PiBXZSdyZSB0ZXN0aW5nIGVuY3J5cHRlZCBBUCArIE1lc2ggcXVpdGUgc3VjY2Vzc2Z1bGx5IHJp
Z2h0IG5vdyB3aXRoDQo+ID4gdGhpcyBmaXJtd2FyZTogaHR0cHM6Ly9naXRodWIuY29tL2t2YWxv
L2F0aDEway1maXJtd2FyZS9jb21taXQvMzA3Y2I0NmINCj4gPiAwNjY2MWViZDMxODY3MjNiNTAw
MmRlNzY5YzdhZGQ4Mywgb2YgY291cnNlIHRoYXQgaXMgZm9yIGEgUUNBNDAxOSBjaGlwLg0KPiA+
IFdoaWNoIGNoaXAgYXJlIHlvdSB1c2luZz8gSSBjYW4gcG9rZSB0aGUgZmlybXdhcmUgZ3V5cyBm
b3IgcG9zc2liaWxpdHkNCj4gPiBvZiBnZXR0aW5nIGEgMTAuNC4zLjIgZmlybXdhcmUgYnVpbGQg
Zm9yIGl0Lg0KPiANCj4gSGkgVGhvbWFzLA0KPiANCj4gdGhhbmtzIGZvciB0aGUgaGludCEgV2Ug
YXJlIHVzaW5nIGFuIG9sZGVyIFFDQTk4ODIuIEkgYXNzdW1lIHlvdXIgZmlybXdhcmUgd2lsbCAN
Cj4gbm90IHdvcmsgZm9yIHRoaXMgb25lPyBJZiB5b3UgY2FuIHBva2UgdGhlIGZpcm13YXJlIGd1
eXMsIHRoYXQgd291bGQgYmUgZ3JlYXQuIA0KPiA6KQ0KDQpIaSBTaW1vbiwNCg0KQWNjb3JkaW5n
IHRvIGZpcm13YXJlIGd1eXMgdGhlIGxhdGVzdCBjb2RlIGNhbiBhY3R1YWxseSBjb21waWxlIGRv
d24gdG8NCmFueSBjaGlwc2V0LCBzbyBpdCBzaG91bGQgc2ltcGx5IGJlIGEgbWF0dGVyIG9mIGdl
dHRpbmcgYnVpbGRzIHJlbGVhc2VkLg0K
