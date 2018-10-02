Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8F2C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D92320645
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:14:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D92320645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJBQ46 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbeJBQ46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:56:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E480087625;
        Tue,  2 Oct 2018 10:14:26 +0000 (UTC)
Received: from localhost (unknown [10.40.205.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A78760469;
        Tue,  2 Oct 2018 10:14:26 +0000 (UTC)
Date:   Tue, 2 Oct 2018 12:14:25 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20181002101424.GA25116@redhat.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D17280C5@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17280C5@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 02 Oct 2018 10:14:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On Tue, Oct 02, 2018 at 09:35:35AM +0000, Tony Chuang wrote:
> 
> Hi Kale & Stanislaw,
> 
> I am working on the driver code and making some changes that Stanislaw
> have mentioned. And I expected that I will finish them tomorrow, what
> should I do after I finished them?
> 
> Should I send an RFCv2, or start a new RFC for it ? Because our driver will
> be renamed from rtwlan to rtw88 for 8822B/8822C

I think RFCv2 since this is is second iteration and name change is part
of it.

Thanks
Stanislaw
