Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:49155 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeILKvu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 06:51:50 -0400
From: Pkshih <pkshih@realtek.com>
To: "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org.kernel-janitors"
        <netdev@vger.kernel.org.kernel-janitors>
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
Date: Wed, 12 Sep 2018 05:48:51 +0000
Message-ID: <1536731296.3877.0.camel@realtek.com> (sfid-20180912_074919_756447_7F32D667)
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
In-Reply-To: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

T24gVHVlLCAyMDE4LTA5LTExIGF0IDEyOjEyICswMDAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBG
aXhlcyBnY2MgJy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+IA0KPiBkcml2
ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0bHdpZmkvYmFzZS5jOiBJbiBmdW5jdGlvbg0KPiAn
cnRsX2MyaF9jb250ZW50X3BhcnNpbmcnOg0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0bHdpZmkvYmFzZS5jOjIzMTM6MTM6IHdhcm5pbmc6DQo+IMKgdmFyaWFibGUgJ2NtZF9zZXEn
IHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBZdWVIYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQoNCkFja2VkLWJ5
OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KVGhhbmtzDQo=
