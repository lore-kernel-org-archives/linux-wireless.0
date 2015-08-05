Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:19633 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbbHENIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 09:08:10 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Paul Stewart <pstew@chromium.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Jeff CF Chen <jeffc@marvell.com>
Subject: RE: [PATCH v2 3/3] mwifiex: fix unable to connect hidden SSID AP on
 DFS channel
Date: Wed, 5 Aug 2015 13:08:07 +0000
Message-ID: <2bd1e852eff74c25a48f1a22eee2b980@SC-EXCH04.marvell.com> (sfid-20150805_150814_553976_E511CC68)
References: <1438691431-3462-1-git-send-email-akarwar@marvell.com>
	<1438691431-3462-3-git-send-email-akarwar@marvell.com>
 <CAMcMvsh=pqCzLbqu2a-uO=7AuiTbKwACoWMP5Go_SbTEQM6WPw@mail.gmail.com>
In-Reply-To: <CAMcMvsh=pqCzLbqu2a-uO=7AuiTbKwACoWMP5Go_SbTEQM6WPw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGkgUGF1bCwNCg0KPiA+ICsgICAgICAgaWYgKG13aWZpZXhfaXNfaGlkZGVuX3NzaWQoJmJzc19k
ZXNjLT5zc2lkKSkgew0KPiA+ICsgICAgICAgICAgICAgICBtd2lmaWV4X2RiZyhwcml2LT5hZGFw
dGVyLCBJTkZPLCAiZm91bmQgaGlkZGVuDQo+IFNTSURcbiIpOw0KPiA+ICsgICAgICAgICAgICAg
ICBmb3IgKGNoaWQgPSAwIDsgY2hpZCA8IE1XSUZJRVhfVVNFUl9TQ0FOX0NIQU5fTUFYOw0KPiBj
aGlkKyspIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAocHJpdi0+aGlkZGVuX2No
YW5bY2hpZF0uY2hhbl9udW1iZXIgPT0gMCkNCj4gew0KPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgcHJpdi0+aGlkZGVuX2NoYW5bY2hpZF0uY2hhbl9udW1iZXIgPQ0KPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBic3MtPmNoYW5uZWwtPmh3X3Zh
bHVlOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJpdi0+aGlkZGVuX2No
YW5bY2hpZF0ucmFkaW9fdHlwZSA9DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGJzcy0+Y2hhbm5lbC0+YmFuZDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHByaXYtPmhpZGRlbl9jaGFuW2NoaWRdLnNjYW5fdHlwZSA9DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIE1XSUZJRVhfU0NBTl9UWVBFX0FDVElW
RTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiBEb2VzIHRo
aXMgbWVhbiBhbiBlbnRyeSB3aWxsIGJlIGNyZWF0ZWQgaW4gcHJpdi0+aGlkZGVuX2NoYW4gZm9y
IGVhY2gNCj4gaGlkZGVuIEJTUywgZXZlbiBpZiBtdWx0aXBsZSBvZiB0aGVtIGV4aXN0IG9uIG9u
ZSBjaGFubmVsPw0KDQpZZXMuIFRoYW5rcyBmb3IgcG9pbnRpbmcgdGhpcyBvdXQuIEkgd2lsbCBz
ZW5kIHVwZGF0ZWQgdmVyc2lvbiB3aXRoIGNvdXBsZSBvZiBvdGhlciBjb3JyZWN0aW9ucy4NCg0K
UmVnYXJkcywNCkFtaXQNCg==
