Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33636 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754334AbdJQB0Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 21:26:24 -0400
From: Pkshih <pkshih@realtek.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Two rtlwifi drivers?
Date: Tue, 17 Oct 2017 01:24:42 +0000
Message-ID: <5B2DA6FDDF928F4E855344EE0A5C39D1058214F2@RTITMBSV07.realtek.com.tw> (sfid-20171017_032627_853963_01DF58B4)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com> <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com> <20171012103450.GA24647@kroah.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
 <20171016075010.GB3044@kroah.com>
In-Reply-To: <20171016075010.GB3044@kroah.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3JlZyBLcm9haC1IYXJ0
bWFuIFttYWlsdG86Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmddDQo+IFNlbnQ6IE1vbmRheSwg
T2N0b2JlciAxNiwgMjAxNyAzOjUwIFBNDQo+IFRvOiBQa3NoaWgNCj4gQ2M6IExhcnJ5IEZpbmdl
cjsgS2FsbGUgVmFsbzsgRGFuIENhcnBlbnRlcjsg6I6K5b2l5a6jOyBKb2hhbm5lcyBCZXJnOyBT
b3VwdGljayBKb2FyZGVyOw0KPiBkZXZlbEBkcml2ZXJkZXYub3N1b3NsLm9yZzsgbGludXgtd2ly
ZWxlc3NAdmdlci5rZXJuZWwub3JnOyBrZXJuZWwtamFuaXRvcnNAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBUd28gcnRsd2lmaSBkcml2ZXJzPw0KPiANCj4gDQo+ID4gNCkgQXMgS2Fs
bGUgbWVudGlvbmVkLCBydGx3aWZpIGNvbnRhaW5zIG1hbnkgbWFnaWMgbnVtYmVycywgYW5kIEkN
Cj4gPiAgICBwbGFuIHRvIGZpeCB0aGVtIGFmdGVyIHJ0bDg3MjNkZSBhbmQgcnRsODgyMWNlLiBC
ZWNhdXNlIHRoZSBkcml2ZXJzDQo+ID4gICAgYXJlIGRldmVsb3BpbmcsIHRoZSBjaGFuZ2VzIHdp
bGwgbWFrZSB1cyBoYXJkIHRvIGludGVncmF0ZS4gSG93ZXZlciwNCj4gPiAgICBJIGRvbid0IGhh
dmUgcGxhbiB0byBwcm9jZXNzIHRoZSBtYWdpYyBudW1iZXJzIGluIHRoZSBtb2R1bGUgcGh5ZG0s
DQo+ID4gICAgYmVjYXVzZSB0aGUgbW9zdCBvZiBCQi9SRiByZWdpc3RlcnMgY29udGFpbiBtYW55
IGZ1bmN0aW9ucy4gQW5kDQo+ID4gICAgaXQgZG9lc24ndCBoYXZlIGEgcmVnaXN0ZXIgbmFtZSBi
dXQgYSBiaXQgZmllbGQgbmFtZSBpbnN0ZWFkLg0KPiA+ICAgIE91ciBCQiB0ZWFtIGd1eXMgc2F5
IHRoZSB1c2Ugb2YgZW51bWVyYXRpb24gb3IgZGVmaW5lZCBuYW1lIHdpbGwNCj4gPiAgICBiZSB1
bnJlYWRhYmxlLCBhbmQgdGhlIG5hbWUgaXMgbWVhbmluZ2xlc3MgZm9yIG1vc3QgcGVvcGxlLg0K
PiANCj4gRG9uJ3QgYmUgc28gc3VyZSB0aGF0IG5hbWVzIGFyZSAibWVhbmluZ2xlc3MiLCB0aGVy
ZSBhcmUgcGVvcGxlIGhlcmUNCj4gdGhhdCBoYXZlIGJlZW4gZG9pbmcgbmV0d29yayBkcml2ZXJz
IGFuZCBkZXZlbG9wbWVudCBmb3IgbG9uZ2VyIHRoYW4NCj4gYW55b25lIGVsc2UgaW4gdGhlIHdv
cmxkLiAgSXQncyBiZXN0IHRvIGF0IGxlYXN0IG5hbWUgdmFsdWVzLCBldmVuIGlmDQo+IHRoZXkg
ZG8gbm90IHNlZW0gdG8gbWFrZSBzZW5zZSwgYXMgdGhhdCB3YXkgdGhlIHZhbHVlIGNhbiBiZSB0
cmFja2VkDQo+IGNvcnJlY3RseSwgYW5kIHBvc3NpYmx5IGJlIHVuZGVyc3Rvb2QgbGF0ZXIgYnkg
c29tZW9uZSBlbHNlLCBvciBldmVuDQo+IHlvdSENCj4gDQoNClRoYW5rcyBmb3IgeW91ciBoZWxw
IHRvIHJlc29sdmUgb3VyIHF1ZXN0aW9ucy4NCkknbGwgcGFzcyB0aGlzIHBvaW50IHRvIHRoZSBn
dXlzLg0KDQpQSw0KDQo=
