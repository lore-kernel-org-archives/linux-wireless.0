Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54398 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755242AbeFYKtO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 06:49:14 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Doug Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/3] mwifiex: cleanup rx_pkt_lock usage in
 11n_rxreorder.c
Date: Mon, 25 Jun 2018 09:49:09 +0000
Message-ID: <a0c9a77cd5f14928ae4b86643e672cc6@SC-EXCH02.marvell.com> (sfid-20180625_124917_570596_AA40DB68)
References: <1509442967-14149-1-git-send-email-gbhat@marvell.com>
 <1509442967-14149-2-git-send-email-gbhat@marvell.com>
 <20171101212853.GA89416@google.com>
 <cb98c452aa344fc0b501a776cfa8708a@SC-EXCH02.marvell.com>
 <CAD=FV=VuxFtDdcMndLNzVYDoid8N3jP46j0sOFXG1D4CzX0=Zw@mail.gmail.com>
 <20171107022508.GA42502@google.com>
 <a4c65d325abd4d4eb45d8cb3cd172df3@SC-EXCH02.marvell.com>
 <CAD=FV=ViNE5gnDTexYKpMN_Bb1bqZHwnJQ0h64=Rc8x-_1=iFQ@mail.gmail.com>
 <46e098fe02c14e16b83fc35753b85805@SC-EXCH02.marvell.com>
In-Reply-To: <46e098fe02c14e16b83fc35753b85805@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgRG91Zy9CcmlhbiwNCj4gPiA+IDEuIE1vdmUgcnhfcGt0X2xvY2sgZnJvbSBtd2lmaWV4X3By
aXZhdGUgdG8gcnhfcmVvcmRlcl90YmwNCj4gPg0KPiA+IC4uLm9yLCBwb3NzaWJseSwgcmVtb3Zl
IHJ4X3BrdF9sb2NrIGNvbXBsZXRlbHkuICBTZWUgbXkgb3RoZXIgcmVzcG9uc2UuLi4NCj4gQWZ0
ZXIgY2hlY2tpbmcgdGhlIGZsb3csIEkgYW0gdGhpbmtpbmcgb2YgcmVtb3ZpbmcgYmVsb3cgMyBz
cGluIGxvY2tzOg0KPiByeF9yZW9yZGVyX3RibF9sb2NrDQo+IHJ4X3BrdF9sb2NrDQo+IHR4X2Jh
X3N0cmVhbV90YmxfbG9jaw0KPiBBcyB5b3UgYm90aCBoYXZlIHBvaW50ZWQgZWFybGllciwgdGhl
eSB1c2VkIGJ5IG1haW4gdGhyZWFkIGFuZCBvY2Nhc2lvbmFsbHkNCj4gYnkgY2ZnODAyMTEgKGZv
ciBURExTIGNvbmZpZ3VyYXRpb24pLg0KPiBDYW4geW91IHBsZWFzZSBjb21tZW50IG9uIHRoaXMg
Y2hhbmdlPyBJcyBpdCBPSyB0byBpZ25vcmUgY2ZnODAyMTEgaGVyZS4NCldlIGhhdmUgd29ya2Vk
IG9uIHRoZSBkaXNjdXNzZWQgY2hhbmdlIGluIHRoaXMgdGhyZWFkIGFuZCBoYXZlIGNvbWUgdXAg
d2l0aCBhIDIgcGF0Y2hlcyB0byBjbGVhbnVwIHJ4X3Jlb3JkZXJfdGJsIGxvY2suDQpLaW5kbHkg
cmV2aWV3IHRoZSBwYXRjaGVzIHVwc3RyZWFtZWQgYmVsb3c6DQpodHRwczovL3BhdGNod29yay5r
ZXJuZWwub3JnL3BhdGNoLzEwNDg1MzY5Lw0KaHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9w
YXRjaC8xMDQ4NTM2Ny8NCj4gPg0KPiA+IC1Eb3VnDQo+DQo+IFJlZ2FyZHMsDQo+IEdhbmFwYXRo
aQ0KVGhhbmtzICYgUmVnYXJkcywNCkdhbmFwYXRoaQ0K
