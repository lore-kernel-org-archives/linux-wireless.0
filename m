Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62909 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbcEDNJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2016 09:09:38 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Belisko Marek <marek.belisko@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: mwifiex 8897 disable 11ac in sta mode
Date: Wed, 4 May 2016 13:04:56 +0000
Message-ID: <a90ef573f6e443b6b968e263d51160c5@SC-EXCH04.marvell.com> (sfid-20160504_151003_840892_4F302B37)
References: <CAAfyv37f-+suz206JR3Cdnzt57b1YEtfgVp0W+5GJ5keWNdnNQ@mail.gmail.com>
In-Reply-To: <CAAfyv37f-+suz206JR3Cdnzt57b1YEtfgVp0W+5GJ5keWNdnNQ@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_a90ef573f6e443b6b968e263d51160c5SCEXCH04marvellcom_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_a90ef573f6e443b6b968e263d51160c5SCEXCH04marvellcom_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgTWFyZWssDQoNCj4gRnJvbTogQmVsaXNrbyBNYXJlayBbbWFpbHRvOm1hcmVrLmJlbGlza29A
Z21haWwuY29tXQ0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAwNCwgMjAxNiA1OjQ4IFBNDQo+IFRv
OiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IEFtaXRrdW1hciBLYXJ3YXINCj4gU3Vi
amVjdDogbXdpZmlleCA4ODk3IGRpc2FibGUgMTFhYyBpbiBzdGEgbW9kZQ0KPiANCj4gSGksDQo+
IA0KPiBpdCBpcyBwb3NzaWJsZSBzb21laG93IHRvIGRpc2FibGUgMTFhYyBpbiBtd2lmaWV4IGRy
aXZlciBmb3Igc3RhIG1vZGUoSQ0KPiB0cmllZCBpbiB3cGFfc3VwcGxpY2FudCBieSBkaXNhYmxl
X3ZodCB3aXRob3V0IHN1Y2Nlc3MpLiBBbnkgaWRlYXM/IE1hbnkNCj4gdGhhbmtzLg0KDQpUaGVy
ZSBpcyBub3Qgc3RhbmRhcmQgd2F5LiBZb3UgY2FuIHRyeSBhdHRhY2hlZCBoYWNrLg0KDQpSZWdh
cmRzLA0KQW1pdGt1bWFyDQo=

--_002_a90ef573f6e443b6b968e263d51160c5SCEXCH04marvellcom_
Content-Type: application/octet-stream; name="disable_11AC.diff"
Content-Description: disable_11AC.diff
Content-Disposition: attachment; filename="disable_11AC.diff"; size=480;
	creation-date="Wed, 04 May 2016 13:03:37 GMT";
	modification-date="Wed, 04 May 2016 13:03:37 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9jbWRldnQu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9jbWRldnQuYwppbmRleCA2
YmMyMDExLi43NWM2MjdiIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxs
L213aWZpZXgvY21kZXZ0LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lm
aWV4L2NtZGV2dC5jCkBAIC0xNTE3LDYgKzE1MTcsOCBAQCBpbnQgbXdpZmlleF9yZXRfZ2V0X2h3
X3NwZWMoc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKIAllbHNlCiAJCWFkYXB0ZXItPmZ3
X2JhbmRzID0gQkFORF9COwogCisJYWRhcHRlci0+ZndfYmFuZHMgJj0gfkJBTkRfQUFDOworCiAJ
YWRhcHRlci0+Y29uZmlnX2JhbmRzID0gYWRhcHRlci0+ZndfYmFuZHM7CiAKIAlpZiAoYWRhcHRl
ci0+ZndfYmFuZHMgJiBCQU5EX0EpIHsK

--_002_a90ef573f6e443b6b968e263d51160c5SCEXCH04marvellcom_--
