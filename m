Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3E2C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 08:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C75FA206BB
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 08:08:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389301AbfBMII4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 03:08:56 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:43581 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbfBMIIz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 03:08:55 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1D88SbS027727, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1D88SbS027727
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 13 Feb 2019 16:08:28 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Wed, 13 Feb 2019 16:08:27 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 03/13] rtw88: hci files
Thread-Topic: [PATCH v4 03/13] rtw88: hci files
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXJdAKAgBDPKrCAAgPPAIAA/aZQ
Date:   Wed, 13 Feb 2019 08:08:27 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A599A@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190131223609.GA191502@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
 <CA+ASDXMGtktTQtwoyCtaYmc9n5+OkXWMJn8FK-nGnoOLrbFe+w@mail.gmail.com>
In-Reply-To: <CA+ASDXMGtktTQtwoyCtaYmc9n5+OkXWMJn8FK-nGnoOLrbFe+w@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQnJpYW4gTm9ycmlzIFtt
YWlsdG86YnJpYW5ub3JyaXNAY2hyb21pdW0ub3JnXQ0KPiANCj4gPiA+ID4gKyAgIGZvciAoaSA9
IDA7IGkgPCBhbGxvY2F0ZWQ7IGkrKykgew0KPiA+ID4gPiArICAgICAgICAgICBza2IgPSByeF9y
aW5nLT5idWZbaV07DQo+ID4gPiA+ICsgICAgICAgICAgIGlmICghc2tiKQ0KPiA+ID4gPiArICAg
ICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KPiA+ID4gPiArICAgICAgICAgICBkbWEgPSAqKChk
bWFfYWRkcl90ICopc2tiLT5jYik7DQo+ID4gPiA+ICsgICAgICAgICAgIHBjaV91bm1hcF9zaW5n
bGUocGRldiwgZG1hLCBidWZfc3osDQo+IFBDSV9ETUFfRlJPTURFVklDRSk7DQo+ID4gPiA+ICsg
ICAgICAgICAgIGRldl9rZnJlZV9za2JfYW55KHNrYik7DQo+ID4gPiA+ICsgICAgICAgICAgIHJ4
X3JpbmctPmJ1ZltpXSA9IE5VTEw7DQo+ID4gPiA+ICsgICB9DQo+ID4gPiA+ICsgICBwY2lfZnJl
ZV9jb25zaXN0ZW50KHBkZXYsIHJpbmdfc3osIGhlYWQsIGRtYSk7DQo+ID4gPiA+ICsNCj4gPiA+
ID4gKyAgIHJ0d19lcnIocnR3ZGV2LCAiZmFpbGVkIHRvIGluaXQgcnggYnVmZmVyXG4iKTsNCj4g
PiA+ID4gKw0KPiA+ID4gPiArICAgcmV0dXJuIHJldDsNCj4gPiA+ID4gK30NCj4gPiA+ID4gKw0K
PiANCj4gLi4uDQo+IA0KPiA+IEFmdGVyIHNvbWUgdGVzdGluZywgdGhpcyBmdW5jdGlvbiBJIHRo
aW5rIGNhbiBiZSByZW1vdmVkLg0KPiA+IChydHdfcGNpX3BhcnNlX2NvbmZpZ3VyYXRpb24pDQo+
IA0KPiBXaHkgd2FzIGl0IGhlcmUgaW4gdGhlIGZpcnN0IHBsYWNlPyBXZXJlIHRoZXJlIGFueSBo
YXJkd2FyZSBxdWlya3MNCj4gdGhhdCB0aGlzIHdhcyBjb3ZlcmluZz8gT3IsIGFyZSB5b3UganVz
dCBzYXlpbmcgdGhhdCB0aGUgZGVmYXVsdA0KPiB2YWx1ZXMgYXJlIGFscmVhZHkgY29ycmVjdCAo
cGx1cywgdGhlIFBDSSBmcmFtZXdvcmsgYWxyZWFkeSBicmluZ3MgeW91DQo+IG91dCBvZiBEMyk/
IEkgZG8gYWxzbyBzZWUgdGhhdCByZW1vdmluZyB0aGlzIGZ1bmN0aW9uIGRvZXNuJ3QgYWN0dWFs
bHkNCj4gaGF2ZSBhIG5ldCBlZmZlY3Qgb24gdGhlIHRoZSBQQ0kgY29uZmlndXJhdGlvbiwganVk
Z2luZyBieSBsc3BjaQ0KPiAtdnZ2eHh4eC4NCg0KVGhpcyB3YXMgd3JpdHRlbiBmb3IgZGV2ZWxv
cGluZyA4ODIyQkUuIEFuZCBpdCB3YXMgbm90IHRlc3RlZCBhdCB0aGF0DQptb21lbnQgc28gSSB3
YXMgbm90IHN1cmUgaWYgaXQgY2FuIGJlIHJlbW92ZWQuIE5vdyBtYW55IHRlc3QgaXRlbSBoYXMN
CmJlZW4gdGVzdGVkLCBpdCBzZWVtcyB0aGF0IHRoZSBjb25maWd1cmF0aW9uIHBhcnNpbmcgY29k
ZSBpcyBubyBtb3JlDQpuZWVkZWQuDQpBbmQgSSBzZWUgdGhhdCBwY2lfc2V0X21hc3RlcigpIHdp
bGwgZW50ZXIgRDAuIFNvIGl0IGNhbiBiZSByZW1vdmVkLg0KDQpUaGFua3MuDQoNCllhbi1Ic3Vh
bg0K
