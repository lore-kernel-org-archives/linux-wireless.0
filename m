Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40254 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750722AbeCOHdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 03:33:43 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH 2/3] mwifiex: fix incorrect ht capability
 problem
Date: Thu, 15 Mar 2018 07:33:39 +0000
Message-ID: <0707bbe6685742ecaf70b15b7a2e65be@SC-EXCH02.marvell.com> (sfid-20180315_083346_735862_A22EF6B9)
References: <1520619326-14888-1-git-send-email-gbhat@marvell.com>
        <1520619326-14888-3-git-send-email-gbhat@marvell.com>
 <877eqfyoga.fsf@purkki.adurom.net>
In-Reply-To: <877eqfyoga.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> Ganapathi Bhat <gbhat@marvell.com> writes:
>
> > IEEE80211_CHAN_NO_HT40PLUS and IEEE80211_CHAN_NO_HT40PLUS
> channel
> > flags tell if HT40 operation is allowed on a channel or not.
> >
> > This patch ensures ht_capability information is modified accordingly
> > so that we don't end up creating a HT40 connection when it's not
> > allowed for current regulatory domain.
> >
> > Signed-off-by: Cathy Luo <cluo@marvell.com>
> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>
> kbuild bot reported sparse warnings from this patch:
>
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65: sparse: invalid
> assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    left side has type
> restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:358:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65: sparse: invalid
> assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    left side has type
> restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:360:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65: sparse: invalid
> assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    left side has type
> restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:366:65:    right side has type int
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65: sparse: invalid
> assignment: &=
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    left side has type
> restricted __le16
> drivers/net/wireless/marvell/mwifiex/11n.c:368:65:    right side has type int
>
> Please submit a followup patch to fix those.
Sorry for the errors. Yes we have submitted a follow up fix.
>
> --
> Kalle Valo

Regards,
Ganapathi
