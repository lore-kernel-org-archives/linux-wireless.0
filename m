Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1844C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 12:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74DF62085A
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 12:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbfCHMjR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 07:39:17 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54631 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbfCHMjR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 07:39:17 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x28CcnY1005816, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x28CcnY1005816
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 8 Mar 2019 20:38:49 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Fri, 8 Mar
 2019 20:38:49 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: RE: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable functionalities
Thread-Topic: [PATCH v2 00/24] rtw88: major fixes for 8822c to have stable
 functionalities
Thread-Index: AQHU1ZtIhYim7tsxxEKEtK5d1ye116YBq0Rg
Date:   Fri, 8 Mar 2019 12:38:48 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17BC3EB@RTITMBSVM04.realtek.com.tw>
References: <1550134743-17443-1-git-send-email-yhchuang@realtek.com>
        <F7CD281DE3E379468C6D07993EA72F84D17AE4FD@RTITMBSVM04.realtek.com.tw>
 <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87a7i58xag.fsf@kamboji.qca.qualcomm.com>
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

> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> 
> Also in another thread I saw something about this driver conflicting
> with a staging driver, is that true? That should be solved before the
> driver is accepted as I don't think two drivers should race for the same
> hardware and the driver is randomly chosen.
> 

I think this could be fixed by removing the staging driver via
wireless-drivers-next as you said before. Can you help me coordinate
this with Greg? Or should I send the patch that removes the staging
driver to you.

Thanks

> 
> --
> Kalle Valo


Yan-Hsuan
