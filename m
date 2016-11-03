Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48105 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754272AbcKCIEP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 04:04:15 -0400
From: Xinming Hu <huxm@marvell.com>
To: Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        "rajatja@google.com" <rajatja@google.com>,
        "briannorris@google.com" <briannorris@google.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: RE: [PATCH v2 1/5] mwifiex: remove redundant condition in main
 process
Date: Thu, 3 Nov 2016 08:04:09 +0000
Message-ID: <eda7a256a6574baeb8e1a12c15c2e6b0@SC-EXCH02.marvell.com> (sfid-20161103_090423_315933_915D0A54)
References: <1477559563-18328-1-git-send-email-akarwar@marvell.com>
 <20161027183536.GA28717@localhost>
In-Reply-To: <20161027183536.GA28717@localhost>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SGksDQoNCldlIGhhdmUgaW5jbHVkZSBiZWxvdyBjaGFuZ2UgaW4gbGF0ZXN0IHN1Ym1pdCBodHRw
czovL3BhdGNod29yay5rZXJuZWwub3JnL3BhdGNoLzk0MDcyODMvDQpQbGVhc2UgZHJvcCB0aGlz
IHBhdGNoLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IGxpbnV4LXdp
cmVsZXNzLW93bmVyQHZnZXIua2VybmVsLm9yZw0KPiBbbWFpbHRvOmxpbnV4LXdpcmVsZXNzLW93
bmVyQHZnZXIua2VybmVsLm9yZ10gT24gQmVoYWxmIE9mIEJyaWFuIE5vcnJpcw0KPiBTZW50OiAy
MDE2xOoxMNTCMjjI1SAyOjM2DQo+IFRvOiBBbWl0a3VtYXIgS2Fyd2FyDQo+IENjOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IENhdGh5IEx1bzsgTmlzaGFudCBTYXJtdWthZGFtOw0K
PiByYWphdGphQGdvb2dsZS5jb207IGJyaWFubm9ycmlzQGdvb2dsZS5jb207IGRtaXRyeS50b3Jv
a2hvdkBnbWFpbC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAxLzVdIG13aWZpZXg6IHJl
bW92ZSByZWR1bmRhbnQgY29uZGl0aW9uIGluIG1haW4NCj4gcHJvY2Vzcw0KPiANCj4gT24gVGh1
LCBPY3QgMjcsIDIwMTYgYXQgMDI6NDI6MzlQTSArMDUzMCwgQW1pdGt1bWFyIEthcndhciB3cm90
ZToNCj4gPiBUaGlzIGNvbmRpdGlvbiB3aGlsZSBjYWxsaW5nIG13aWZpZXhfY2hlY2tfcHNfY29u
ZCgpIGlzIHJlZHVuZGFudC4NCj4gPiBUaGUgZnVuY3Rpb24gaW50ZXJuYWxseSBhbHJlYWR5IHRh
a2VzIGNhcmUgb2YgaXQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbWl0a3VtYXIgS2Fyd2Fy
IDxha2Fyd2FyQG1hcnZlbGwuY29tPg0KPiA+IC0tLQ0KPiA+IHYyOiBTYW1lIGFzIHYxDQo+IA0K
PiBZb3UndmUgb21pdHRlZCB0aGUgUmV2aWV3ZWQtYnkgdGFncyBmcm9tIHYxOg0KPiANCj4gUmV2
aWV3ZWQtYnk6IEJyaWFuIE5vcnJpcyA8YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnPg0K
