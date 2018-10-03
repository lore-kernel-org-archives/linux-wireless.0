Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14268C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B1702082A
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 03:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B1702082A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbeJCKM1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 06:12:27 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:32825 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeJCKM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 06:12:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w933PcUl009222, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w933PcUl009222
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 3 Oct 2018 11:25:38 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Wed, 3 Oct
 2018 11:25:38 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH 01/12] rtwlan: main files
Thread-Topic: [PATCH 01/12] rtwlan: main files
Thread-Index: AQHUVmkc7fXueOv/LUWUMOOpXqM0maUFAMQw///nxICAAImvEIAGRY9A//+Gr4CAAaWg0A==
Date:   Wed, 3 Oct 2018 03:25:37 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17289C2@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D17280C5@RTITMBSVM01.realtek.com.tw>
 <20181002101424.GA25116@redhat.com>
In-Reply-To: <20181002101424.GA25116@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Tuesday, October 02, 2018 6:14 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net;
> linux-wireless@vger.kernel.org; Pkshih; Andy Huang
> Subject: Re: [PATCH 01/12] rtwlan: main files
> 
> Hi
> 
> On Tue, Oct 02, 2018 at 09:35:35AM +0000, Tony Chuang wrote:
> >
> > Hi Kale & Stanislaw,
> >
> > I am working on the driver code and making some changes that Stanislaw
> > have mentioned. And I expected that I will finish them tomorrow, what
> > should I do after I finished them?
> >
> > Should I send an RFCv2, or start a new RFC for it ? Because our driver will
> > be renamed from rtwlan to rtw88 for 8822B/8822C
> 
> I think RFCv2 since this is is second iteration and name change is part
> of it.
> 
> Thanks
> Stanislaw
> 

Can I add you as Reviewed-by in RFCv2 ?
You helped me a lot :)

Thanks
Yan-Hsuan Chuang

