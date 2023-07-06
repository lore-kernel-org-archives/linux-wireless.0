Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC41EB64DA
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Jul 2023 01:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbjGFBt7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Jul 2023 21:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbjGFBt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2023 21:49:58 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B67C0E57;
        Wed,  5 Jul 2023 18:49:56 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3661nbrnF018807, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3661nbrnF018807
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 6 Jul 2023 09:49:37 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Thu, 6 Jul 2023 09:49:41 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 6 Jul 2023 09:49:41 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Thu, 6 Jul 2023 09:49:41 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Zhang Shurong <zhang_shurong@foxmail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] wifi: rtw89: debug: fix error code in rtw89_debug_priv_send_h2c_set()
Thread-Topic: [PATCH v3] wifi: rtw89: debug: fix error code in
 rtw89_debug_priv_send_h2c_set()
Thread-Index: AQHZr1PDKN54W8TZNEupDd7m1ygpGK+r+Pkw
Date:   Thu, 6 Jul 2023 01:49:41 +0000
Message-ID: <f1c97de4a97f4225ac0e67778b90bdd4@realtek.com>
References: <tencent_D74C0118F55D22E6A6B1767CCB01CCC1E305@qq.com>
In-Reply-To: <tencent_D74C0118F55D22E6A6B1767CCB01CCC1E305@qq.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Zhang Shurong <zhang_shurong@foxmail.com>
> Sent: Wednesday, July 5, 2023 11:11 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: kvalo@kernel.org; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org; Zhang Shurong
> <zhang_shurong@foxmail.com>
> Subject: [PATCH v3] wifi: rtw89: debug: fix error code in rtw89_debug_priv_send_h2c_set()
> 
> If there is a failure during rtw89_fw_h2c_raw() rtw89_debug_priv_send_h2c
> should return negative error code instead of a positive value count.
> Fix this bug by returning correct error code.
> 
> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
> 

No need a blank line here. 

> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

[...]

