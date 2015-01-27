Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26645 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbA0N6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 08:58:08 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: introduce struct ath10k_skb_rxcb
References: <1421407029-23967-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 27 Jan 2015 15:57:54 +0200
In-Reply-To: <1421407029-23967-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 16 Jan 2015 12:17:08 +0100")
Message-ID: <877fw8com5.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_145812_041189_4D7C0578)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It doesn't make much sense to share the
> ath10k_skb_cb with Rx path. The Rx path doesn't
> need to keep any mac80211's data.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, both patches applied to ath.git.

-- 
Kalle Valo
