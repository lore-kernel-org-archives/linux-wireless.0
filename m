Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46213 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbFHIqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:46:32 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [PATCHv5,
 01/17] mwifiex: verbose logging for association failure messages
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433330987-6808-2-git-send-email-patila@marvell.com>
To: Avinash Patil <patila@marvell.com>
Cc: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Message-Id: <20150608084631.C91DA140775@smtp.codeaurora.org> (sfid-20150608_104635_816787_28264633)
Date: Mon,  8 Jun 2015 08:46:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch adds more detailed information about association failures
>  - reason and states.
> 
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

Thanks, 17 patches applied to wireless-drivers-next.git:

12d111097428 mwifiex: verbose logging for association failure messages
c951a6671340 mwifiex: correct bss_type assignment
ed5cfbe6ba27 mwifiex: support AP reset after bss_stop
88af6f053ad8 mwifiex: enable 11d after bss reset
7b7166256d27 mwifiex: reset 11h active flag when chandef does not require dfs
511c8989fe5a mwifiex: disable CAC upon radar detection event
7ee38bf4edea mwifiex: add cfg80211 get_channel handler
442f6f9b49c8 mwifiex: maintain station statistic in uap mode
b21783e94e20 mwifiex: add sta_list firmware command
8baca1a34d4c mwifiex: dump station support in uap mode
8a73dd639889 mwifiex: parse power constraint IE from Tail
e4f59aca0b63 mwifiex: support downloading IEs from tail
3e6f8a4b955f mwifiex: drop block-ack action frames
c2b6680f63ff mwifiex: advertise PS ON by default support to cfg80211
debfc6008169 mwifiex: update AP WMM settings from BSS_START event
719a25e33153 mwifiex: using right tid for addressing ra_list
ec264a43029f mwifiex: do not decrease tx_pending for AMSDU packet once more

Kalle Valo
