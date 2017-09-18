Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753017AbdIRONq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 10:13:46 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
Date: Mon, 18 Sep 2017 14:13:41 +0000
Message-ID: <3f3f5c9672a5421db05337a00d9578f2@SC-EXCH02.marvell.com> (sfid-20170918_161350_086438_6517388D)
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
 <87o9q8kuy4.fsf@purkki.adurom.net>
In-Reply-To: <87o9q8kuy4.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,
> 
> > Avoid calculating random MAC address in driver. Instead make use of
> > 'get_random_mask_addr()' function.
> >
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> 
> I don't see 1/2 anywhere. Did it get lost?
Actually there is no 1/2. What I did is: 'git send-email'; CTRL + C (to correct a typo); and then tried sending it again. I think that created some problem here. Kindly let me know how to proceed. 

Thanks,
Ganapathi
> 
> --
> Kalle Valo
