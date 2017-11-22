Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43950 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751258AbdKVGyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 01:54:25 -0500
From: Xinming Hu <huxm@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        "Dmitry Torokhov" <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>
Subject: RE: [PATCH v2] mwifiex: do not support change AP interface to station
 mode
Date: Wed, 22 Nov 2017 06:53:55 +0000
Message-ID: <de70a382a796439a9bf3975349b7a111@SC-EXCH02.marvell.com> (sfid-20171122_075430_067979_1B410925)
References: <1511265815-13087-1-git-send-email-huxm@marvell.com>
 <20171121193117.GB5400@us.netrek.org>
In-Reply-To: <20171121193117.GB5400@us.netrek.org>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgSmFtZXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogcXVvemxA
bGFwdG9wLm9yZyBbbWFpbHRvOnF1b3psQGxhcHRvcC5vcmddDQo+IFNlbnQ6IDIwMTfE6jEx1MIy
MsjVIDM6MzENCj4gVG86IFhpbm1pbmcgSHUgPGh1eG1AbWFydmVsbC5jb20+DQo+IENjOiBMaW51
eCBXaXJlbGVzcyA8bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnPjsgS2FsbGUgVmFsbw0K
PiA8a3ZhbG9AY29kZWF1cm9yYS5vcmc+OyBCcmlhbiBOb3JyaXMgPGJyaWFubm9ycmlzQGNocm9t
aXVtLm9yZz47IERtaXRyeQ0KPiBUb3Jva2hvdiA8ZHRvckBnb29nbGUuY29tPjsgcmFqYXRqYUBn
b29nbGUuY29tOyBaaGl5dWFuIFlhbmcNCj4gPHlhbmd6eUBtYXJ2ZWxsLmNvbT47IFRpbSBTb25n
IDxzb25ndGFvQG1hcnZlbGwuY29tPjsgQ2F0aHkgTHVvDQo+IDxjbHVvQG1hcnZlbGwuY29tPjsg
SmFtZXMgQ2FvIDxqY2FvQG1hcnZlbGwuY29tPjsgR2FuYXBhdGhpIEJoYXQNCj4gPGdiaGF0QG1h
cnZlbGwuY29tPjsgRWxsaWUgUmVldmVzIDxlbGxpZXJldnZlc0BnbWFpbC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggdjJdIG13aWZpZXg6IGRvIG5vdCBzdXBwb3J0IGNoYW5nZSBBUCBpbnRl
cmZhY2UgdG8gc3RhdGlvbg0KPiBtb2RlDQo+IA0KPiBPbiBUdWUsIE5vdiAyMSwgMjAxNyBhdCAw
ODowMzozNVBNICswODAwLCBYaW5taW5nIEh1IHdyb3RlOg0KPiA+IEZpcm13YXJlIGRvIG5vdCBz
dXBwb3J0IGNoYW5nZSBpbnRlcmZhY2UgZnJvbSBtaWNyby1hcCBtb2RlIHRvIHN0YXRpb24NCj4g
PiBtb2RlLCBmb3JiaWRkZW4gdGhpcyBvcGVyYXRpb24gaW4gZHJpdmVyIGFjY29yZGluZ2x5Lg0K
PiANCj4gImZvcmJpZGRlbiIgc2hvdWxkIGJlICJmb3JiaWQiLCBmb3IgY29ycmVjdCB0ZW5zZS4N
Cj4gDQo+ICJpbiBkcml2ZXIiIGlzIHJlZHVuZGFudCBhbmQgY2FuIGJlIHJlbW92ZWQuDQo+IA0K
PiAiYWNjb3JkaW5nbHkiIGlzIGFsc28gcmVkdW5kYW50Lg0KPiANCj4gUGVyaGFwcyAiRmlybXdh
cmUgZG8gbm90IHN1cHBvcnQgY2hhbmdlIGludGVyZmFjZSBmcm9tIG1pY3JvLWFwIG1vZGUgdG8N
Cj4gc3RhdGlvbiBtb2RlLCBmb3JiaWQgdGhpcyBvcGVyYXRpb24uIg0KPiANCg0KT2ssIGl0IGxv
b2tzIGJldHRlci4NCg0KPiA+IFNpZ25lZC1vZmYtYnk6IENhdGh5IEx1byA8Y2x1b0BtYXJ2ZWxs
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBYaW5taW5nIEh1IDxodXhtQG1hcnZlbGwuY29tPg0K
PiA+IC0tLQ0KPiA+IHYyOiByZW1vdmUgdW5uZWNlc3Nhcnkgc3RhL3VhcCBjb21ibyBjaGVjayhK
YW1lcyBDYW1lcm9uKQ0KPiA+DQo+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdp
ZmlleC9jZmc4MDIxMS5jIHwgMSAtDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0p
DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lm
aWV4L2NmZzgwMjExLmMNCj4gPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmll
eC9jZmc4MDIxMS5jDQo+ID4gaW5kZXggNmUwZDlhOS4uNGQ0NWRmOCAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvY2ZnODAyMTEuYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9jZmc4MDIxMS5jDQo+ID4g
QEAgLTExODAsNyArMTE4MCw2IEBAIHN0YXRpYyBpbnQgbXdpZmlleF9kZWluaXRfcHJpdl9wYXJh
bXMoc3RydWN0DQo+IG13aWZpZXhfcHJpdmF0ZSAqcHJpdikNCj4gPiAgCWNhc2UgTkw4MDIxMV9J
RlRZUEVfQVA6DQo+ID4gIAkJc3dpdGNoICh0eXBlKSB7DQo+ID4gIAkJY2FzZSBOTDgwMjExX0lG
VFlQRV9BREhPQzoNCj4gDQo+IENoYW5nZSBpbnRlcmZhY2UgdHlwZSBmcm9tIG1pY3JvLWFwIHRv
IGFkaG9jIGlzIHN1cHBvcnRlZD8NCg0KWWVzLCBpdCBpcyBzdXBwb3J0ZWQgaW4gRlcuDQoNCj4g
DQo+ID4gLQkJY2FzZSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OOg0KPiA+ICAJCQlyZXR1cm4gbXdp
ZmlleF9jaGFuZ2VfdmlmX3RvX3N0YV9hZGhvYyhkZXYsIGN1cnJfaWZ0eXBlLA0KPiA+ICAJCQkJ
CQkJICAgICAgIHR5cGUsIHBhcmFtcyk7DQo+ID4gIAkJCWJyZWFrOw0KPiA+IC0tDQo+ID4gMS45
LjENCj4gPg0KPiANCj4gLS0NCj4gSmFtZXMgQ2FtZXJvbg0KPiBodHRwOi8vcXVvemwubmV0cmVr
Lm9yZy8NCg==
