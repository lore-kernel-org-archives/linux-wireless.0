Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17580 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbcCDIrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:47:40 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "grzegorz.bajorski@tieto.com" <grzegorz.bajorski@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: deliver mgmt frames from htt to monitor vifs only
Date: Fri, 4 Mar 2016 08:47:36 +0000
Message-ID: <87oaauy6ho.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_094744_041585_68BDF360)
References: <1448888219-2798-1-git-send-email-grzegorz.bajorski@tieto.com>
In-Reply-To: <1448888219-2798-1-git-send-email-grzegorz.bajorski@tieto.com>
	(Grzegorz Bajorski's message of "Mon, 30 Nov 2015 13:56:59 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grzegorz Bajorski <grzegorz.bajorski@tieto.com> writes:

> Until now only WMI originating mgmt frames were
> reported to mac80211. Management frames on HTT
> were basically dropped (except frames which looked
> like management but had FCS error).
>
> To allow sniffing all frames (including offloaded
> frames) without interfering with mac80211
> operation and states a new rx_flag was introduced
> and is not being used to distinguish frames and
> classify them for mac80211.
>
> Signed-off-by: Grzegorz Bajorski <grzegorz.bajorski@tieto.com>
> ---
> depends on:
> mac80211: allow drivers to report (non-)monitor frames

Note to patchwork:

178830481eee mac80211: allow drivers to report (non-)monitor frames

Is in net-next at the moment.

-- 
Kalle Valo