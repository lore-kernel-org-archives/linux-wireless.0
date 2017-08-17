Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:21169 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751620AbdHQOCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 10:02:52 -0400
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "jikos@kernel.org" <jikos@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        "Weinehall, David" <david.weinehall@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Sharon, Sara" <sara.sharon@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: Re: [linuxwifi] x86/thermal: AB-BA dependency between mvm->mutex
 and tz->lock
Date: Thu, 17 Aug 2017 14:02:47 +0000
Message-ID: <1502978566.15969.308.camel@intel.com> (sfid-20170817_160308_712316_0D220FA0)
References: <alpine.LSU.2.20.1707311300440.4705@cbobk.fhfr.pm>
          <alpine.LSU.2.20.1708031107230.30597@cbobk.fhfr.pm>
          <1501753405.15969.43.camel@intel.com>
          <87vam5nf4w.fsf@kamboji.qca.qualcomm.com>
         <1501759724.15969.49.camel@intel.com>
         <alpine.LSU.2.20.1708031330570.30597@cbobk.fhfr.pm>
         <alpine.LSU.2.20.1708031507290.30597@cbobk.fhfr.pm>
         <alpine.LSU.2.20.1708171537380.3581@cbobk.fhfr.pm>
In-Reply-To: <alpine.LSU.2.20.1708171537380.3581@cbobk.fhfr.pm>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVGh1LCAyMDE3LTA4LTE3IGF0IDE1OjM4ICswMjAwLCBKaXJpIEtvc2luYSB3cm90ZToNCj4g
SGksDQo+IA0KPiBhbnl0aGluZyBuZXcgb24gdGhpcyBmcm9udCBwbGVhc2U/DQo+IA0KPiBUaGUg
c3BsYXQgKGFuZCB0aGVyZWZvcmUgZGVhZGxvY2sgcG90ZW50aWFsKSBpcyBzdGlsbCB0aGVyZSB3
aXRoIGN1cnJlbnQgDQo+IExpbnVzJyB0cmVlLg0KDQpTb3JyeSwgaGF2ZW4ndCBoYWQgbW9yZSB0
aW1lIHRvIHNwZW5kIG9uIGl0LiAgSSdsbCBkbyBpdCB0aGlzIGV2ZW5pbmcuDQoNCkJ1dCwganVz
dCB0byBjbGFyaWZ5LCB0aGUgZGVhZGxvY2sgcG90ZW50aWFsIGhhcyBiZWVuIHRoZXJlIGZvciBh
IHdoaWxlLA0KcmlnaHQ/IFRoZSBvbmx5IGRpZmZlcmVuY2UgaXMgdGhhdCBub3cgd2UgZ2V0IHRo
ZSBzcGxhdC4NCg0KTm90IHNheWluZyB3ZSBzaG91bGRuJ3QgZml4IGl0IHRob3VnaC4gOykNCg0K
LS0NCkx1Y2Eu
