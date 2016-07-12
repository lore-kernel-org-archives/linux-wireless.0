Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32736 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879AbcGLLnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 07:43:33 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>,
	linuxwifi <linuxwifi@intel.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"Sharon, Sara" <sara.sharon@intel.com>,
	"weiyj_lk@163.com" <weiyj_lk@163.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>
Subject: Re: [PATCH -next] iwlwifi: mvm: use setup_timer instead of
 init_timer and data fields
Date: Tue, 12 Jul 2016 11:43:27 +0000
Message-ID: <1468323809.23338.1.camel@intel.com> (sfid-20160712_134337_160419_EE6B5A4B)
References: <1468323657-5909-1-git-send-email-weiyj_lk@163.com>
In-Reply-To: <1468323657-5909-1-git-send-email-weiyj_lk@163.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE2LTA3LTEyIGF0IDExOjQwICswMDAwLCB3ZWl5al9sa0AxNjMuY29tIHdyb3Rl
Og0KPiBGcm9tOiBXZWkgWW9uZ2p1biA8eW9uZ2p1bl93ZWlAdHJlbmRtaWNyby5jb20uY24+DQo+
IA0KPiBVc2Ugc2V0dXBfdGltZXIgZnVuY3Rpb24gaW5zdGVhZCBvZiBpbml0aWFsaXppbmcgdGlt
ZXIgd2l0aCB0aGUNCj4gZnVuY3Rpb24NCj4gYW5kIGRhdGEgZmllbGRzDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBXZWkgWW9uZ2p1biA8eW9uZ2p1bl93ZWlAdHJlbmRtaWNyby5jb20uY24+DQo+IC0t
LQ0KDQpUaGFua3MgLSBJIHBpY2tlZCBpdCB1cCBhbmQgdXBsb2FkZWQgaXQgdG8gb3VyIGludGVy
bmFsIHRyZWUuDQo=
