Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6572 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Sep 2013 02:42:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 0/4] ath10k: improve RX performance
References: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 24 Sep 2013 09:42:21 +0300
In-Reply-To: <1379335757-15180-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 16 Sep 2013 14:49:13 +0200")
Message-ID: <87mwn2bu0i.fsf@kamboji.qca.qualcomm.com> (sfid-20130924_084233_569573_20421F58)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patchset gives clear RX performance
> improvement on AP135. Throughput is at least
> doubled (300mbps -> 600mbps, UDP RX, 2x2).
>
> Patches depend on my RFC patch "mac80211: support
> reporting A-MSDU subframes individually".

Preferably I can apply these changes only after the mac80211 patch goes
to net-next (to avoid unnecessary rebasing). Is there a way to
workaround the need for the mac80211 patch in ath10k so that we could
apply these patches ASAP? And once the mac80211 patch is commited we
could just remove the workaround in ath10k.

-- 
Kalle Valo
