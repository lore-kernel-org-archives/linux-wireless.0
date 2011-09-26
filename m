Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59800 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab1IZWTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 18:19:11 -0400
From: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
To: Henrik Friedrichsen <hrkfdn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Sep 2011 15:19:10 -0700
Subject: RE: iwlagn: "Intel Centrino Advanced-N 6205 AGN" and "AVM Fritz!Box
 (7390)" incompatible
Message-ID: <C5A7FB31FD9AEA42B600BDC3C74F8E00170F307E@orsmsx511.amr.corp.intel.com> (sfid-20110927_001915_158639_9922ED48)
References: <CAJTrwG5M5QtS_jw-WmbSb5_NT+m6JcBD0uHCyUzEYhn94G3rkA@mail.gmail.com>
	<CAJTrwG5eELbDuGFXU4=3gSunPSkKLFvcpSe6gGE_Wc0s5BXZ+A@mail.gmail.com>
	<CAJTrwG7tzDHxDha5x8r-GJFK=oUE6Zk5zqpN4z4L2LyAD=DueQ@mail.gmail.com>
	<1317050380.1958.13.camel@wwguy-huron>
	<CAJTrwG46qRYvda1vcCZXv0BTUyf26gx2qgpNgOG-bm-BCMpqfg@mail.gmail.com>
	<1317053131.1958.15.camel@wwguy-huron>
	<C5A7FB31FD9AEA42B600BDC3C74F8E0017052223@orsmsx511.amr.corp.intel.com>
	<CAJTrwG5AvbtNRZi54tzAoUDv5X9QLVY3L=-OgHYRtnJ-RMesrQ@mail.gmail.com>
	<1317062004.1958.18.camel@wwguy-huron>
	<CAJTrwG57r-B-eT-FODsDW1UgoVcS68zcUWo1mOrdHRdoXtNmCg@mail.gmail.com>
	<C5A7FB31FD9AEA42B600BDC3C74F8E001705253B@orsmsx511.amr.corp.intel.com>
	<CAJTrwG5MXfixhnNPOdoA3-DYEeKpC==uv4WvE78ZE5U+A10T7Q@mail.gmail.com>
	<1317071501.2400.10.camel@wwguy-ubuntu>
	<CAJTrwG6_ybjD9u2zMi+bY73j6CZoncbmOzk8N2N=8Cd=EWLUcA@mail.gmail.com>
	<1317071853.2400.11.camel@wwguy-ubuntu>
	<CAJTrwG5ydoheYzYuRZaaR0AfqBgE9KnfYQ8X_0esRNVog3hF=g@mail.gmail.com>
	<4E80F522.3010903@lwfinger.net>
 <CAJTrwG6r2ZEUg8VugVxDQ_AKL6_ukdregydm-_r9SjUMNbwBHQ@mail.gmail.com>
In-Reply-To: <CAJTrwG6r2ZEUg8VugVxDQ_AKL6_ukdregydm-_r9SjUMNbwBHQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGVucmlrLA0KDQo+PiBPZiBjb3Vyc2UsIGl0IHNob3VsZCB0YWtlIGEgbGl0dGxlIG92ZXIgNCBz
ZWMuIFRyeSBhZGRpbmcgdGhlIC1EDQo+PiBzd2l0Y2ggdG8gdGhlIHBpbmcgY29tbWFuZC4gRG9l
cyByZXBlYXRpbmcgdGhlIHBpbmcgY29tbWFuZA0KPj4gaW1tZWRpYXRlbHkgY2hhbmdlIHRoZSB0
aW1pbmc/DQo+DQo+VGhlcmUgeW91IGdvOg0KPn4gPiBwaW5nIC1EYzUgZnJpdHouYm94DQo+UElO
RyBmcml0ei5ib3ggKDE5Mi4xNjguMTc4LjEpIDU2KDg0KSBieXRlcyBvZiBkYXRhLg0KPlsxMzE3
MDc0Nzk2LjE0MDQ2OF0gNjQgYnl0ZXMgZnJvbSBmcml0ei5ib3ggKDE5Mi4xNjguMTc4LjEpOg0K
PmljbXBfcmVxPTEgdHRsPTY0IHRpbWU9MS4xOSBtcw0KPlsxMzE3MDc0ODA0LjE1NDQyNV0gNjQg
Ynl0ZXMgZnJvbSBmcml0ei5ib3ggKDE5Mi4xNjguMTc4LjEpOg0KPmljbXBfcmVxPTIgdHRsPTY0
IHRpbWU9MS41MiBtcw0KPlsxMzE3MDc0ODEyLjE2NTk0N10gNjQgYnl0ZXMgZnJvbSBmcml0ei5i
b3ggKDE5Mi4xNjguMTc4LjEpOg0KPmljbXBfcmVxPTMgdHRsPTY0IHRpbWU9MS4yMCBtcw0KPlsx
MzE3MDc0ODIwLjE3NzI1Ml0gNjQgYnl0ZXMgZnJvbSBmcml0ei5ib3ggKDE5Mi4xNjguMTc4LjEp
Og0KPmljbXBfcmVxPTQgdHRsPTY0IHRpbWU9MS4yMyBtcw0KPlsxMzE3MDc0ODI4LjE4NzQ3MF0g
NjQgYnl0ZXMgZnJvbSBmcml0ei5ib3ggKDE5Mi4xNjguMTc4LjEpOg0KPmljbXBfcmVxPTUgdHRs
PTY0IHRpbWU9MS43NiBtcw0KPg0KPk5vcGUsIGl0IGRvZXNuJ3QuDQoNCltNVl0gWW91J3ZlIHBy
b2JhYmx5IGFscmVhZHkgZG9uZSB0aGlzLCBidXQgd2hhdCBhYm91dCBpZiB5b3UgY29ubmVjdGVk
IHRvIHRoZSBBUCB2aWEgYW4gRXRoZXJuZXQgY2FibGUsIGFuZCB0aGVuIHRyaWVkIHRoZSBwaW5n
Pw0KDQpNZWVuYWtzaGkNCg==
