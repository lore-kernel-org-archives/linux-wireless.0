Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57701 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965163AbbKEE6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 23:58:20 -0500
Date: Thu, 5 Nov 2015 10:28:00 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 0/3] Fix few WMI/HTT interfaces
Message-ID: <20151105045754.GA12919@qca.qualcomm.com> (sfid-20151105_055824_616658_CC004DCD)
References: <1446638737-7953-1-git-send-email-vthiagar@qti.qualcomm.com>
 <87h9l1bq7o.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87h9l1bq7o.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2015 at 07:59:39PM +0200, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com> writes:
> 
> > This patch set fixes mismatch in peer_assoc complete wmi command for
> > version 10.4 and peer_id configuration for HTT version < 3.4.
> >
> > V2:
> > 	- Add cover letter
> > 	- Rename ath10k_mac_need_offchan_tx_work() to
> > 	  ath10k_mac_tx_frm_has_freq(). Add htt-op-version check
> > 	  to the helper and use it in ath10k_htt_tx() while configuring
> > 	  peerid.
> >
> > Vasanthakumar Thiagarajan (3):
> >   ath10k: Fix peer assoc complete WMI command for 10.4
> >   ath10k: Rename the helper which is used for off-channel tx
> >   ath10k: Fix peerid configuration in htt tx desc for htt version < 3.4
> 
> These had a conflict but you didn't use ath.git as the baseline so I
> can't easily fix them. Please try always to use clean ath.git master
> branch as the baseline for your patches.
> 
> Applying: ath10k: Fix peer assoc complete WMI command for 10.4
> fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/wmi.h).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0001 ath10k: Fix peer assoc complete WMI command for 10.4

Sorry for this. I prepared these patches on ath:master on top of my other pending
patch set. Not sure what went wrong. Ill resend this. Thanks.

Vasanth
