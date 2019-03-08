Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC4EC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DCD520661
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 13:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727604AbfCHM4C convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 07:56:02 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55742 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727593AbfCHMz6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 07:55:58 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x28Ctm7E008193, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x28Ctm7E008193
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 8 Mar 2019 20:55:48 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Fri, 8 Mar 2019
 20:55:48 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Tony Chuang <yhchuang@realtek.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: RE: [PATCH] rtw88: RTL8822C: update rtw8822c_fw.bin to v5.0
Thread-Topic: [PATCH] rtw88: RTL8822C: update rtw8822c_fw.bin to v5.0
Thread-Index: AQHU0mWzcRVoBdg3FE2RA68oy1sPdqYBttkw
Date:   Fri, 8 Mar 2019 12:55:47 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17BC416@RTITMBSVM04.realtek.com.tw>
References: <1551688447-26712-1-git-send-email-yhchuang@realtek.com>
In-Reply-To: <1551688447-26712-1-git-send-email-yhchuang@realtek.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of
> yhchuang@realtek.com
> Sent: Monday, March 04, 2019 4:34 PM
> To: linux-firmware@kernel.org
> Cc: linux-wireless@vger.kernel.org; Larry.Finger@lwfinger.net
> Subject: [PATCH] rtw88: RTL8822C: update rtw8822c_fw.bin to v5.0
> 
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> Add IQK support.
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  rtw88/rtw8822c_fw.bin | Bin 162064 -> 184640 bytes
>  1 file changed, 0 insertions(+), 0 deletions(-)

Ping here.
