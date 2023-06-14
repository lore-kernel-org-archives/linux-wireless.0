Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E49EB64DA
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 08:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243126AbjFNIW1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 04:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbjFNIW0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 04:22:26 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09740CA
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 01:22:23 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 35E8LqtrE005312, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 35E8LqtrE005312
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 14 Jun 2023 16:21:52 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 14 Jun 2023 16:22:10 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Jun 2023 16:22:10 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 14 Jun 2023 16:22:10 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Dmitry Antipov <dmantipov@yandex.ru>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Kalle Valo" <kvalo@kernel.org>
Subject: RE: [PATCH 3/3] [v6] wifi: rtw89: fix spelling typo of IQK debug messages
Thread-Topic: [PATCH 3/3] [v6] wifi: rtw89: fix spelling typo of IQK debug
 messages
Thread-Index: AQHZnph8k+grYMg94EegHUdD+8T1qq+J9Pbg
Date:   Wed, 14 Jun 2023 08:22:10 +0000
Message-ID: <2df6ca14ec254119a79edbfd3648eef8@realtek.com>
References: <20230614051116.20968-3-dmantipov@yandex.ru>
 <20230614081555.91395-1-dmantipov@yandex.ru>
 <20230614081555.91395-3-dmantipov@yandex.ru>
In-Reply-To: <20230614081555.91395-3-dmantipov@yandex.ru>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Dmitry Antipov <dmantipov@yandex.ru>
> Sent: Wednesday, June 14, 2023 4:16 PM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: linux-wireless@vger.kernel.org; Kalle Valo <kvalo@kernel.org>; Dmitry Antipov <dmantipov@yandex.ru>
> Subject: [PATCH 3/3] [v6] wifi: rtw89: fix spelling typo of IQK debug messages
> 
> Fix spelling typo of IQK debug messages.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

It looks not so good to have the same subject and commit message, but this
patch is just to correct typo, so ... 

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


