Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6979C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A3120665
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 09:36:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8A3120665
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbeJWR6d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 13:58:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58219 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbeJWR6d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 13:58:33 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w9N9ZmVE030877, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w9N9ZmVE030877
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 23 Oct 2018 17:35:48 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 23 Oct
 2018 17:35:48 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "zhongjiang@huawei.com" <zhongjiang@huawei.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: remove set but not used variable 'radiob_array_table' and 'radiob_arraylen'
Thread-Topic: [PATCH v2] rtlwifi: remove set but not used variable
 'radiob_array_table' and 'radiob_arraylen'
Thread-Index: AQHUaqwWhqcVPdyTf0GD+7a2PdeLy6UsC/CA
Date:   Tue, 23 Oct 2018 09:35:47 +0000
Message-ID: <1540287313.27623.0.camel@realtek.com>
References: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>
In-Reply-To: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DFE95F0C7812740BEF647EF1D104DD3@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gVHVlLCAyMDE4LTEwLTIzIGF0IDE2OjI4ICswODAwLCB6aG9uZyBqaWFuZyB3cm90ZToNCj4g
cmFkaW9iX2FycmF5X3RhYmxlJyBhbmQgJ3JhZGlvYl9hcnJheWxlbicgYXJlIG5vdCB1c2VkIGFm
dGVyIHNldHRpbmcgaXRzDQo+IHZhbHVlLg0KPiBJdCBpcyBzYWZlIHRvIHJlbW92ZSB0aGUgdW51
c2VkIHZhcmlhYmxlLiBNZWFud2hpbGUsIHJhZGlvIEIgcmFkaW8gc2hvdWxkIGJlDQo+IHJlbW92
ZWQgYXMgd2VsbC4gYmVjYXVzZSBpdCB3aWxsIG5vIGxvbmdlciBiZSByZWZlcmVuY2VkLg0KPiAN
Cj4gU2lnbmVkLW9mZi1ieTogemhvbmcgamlhbmcgPHpob25namlhbmdAaHVhd2VpLmNvbT4NCj4g
DQoNCkFja2VkLWJ5OiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT4NCg0KVGhhbmsg
eW91DQoNCg==
