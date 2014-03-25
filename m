Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63140 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaCYIBA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 04:01:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: dont call csa_finish more than once
References: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 25 Mar 2014 10:00:54 +0200
In-Reply-To: <1395410520-26939-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 21 Mar 2014 15:02:00 +0100")
Message-ID: <87d2ha3dxl.fsf@kamboji.qca.qualcomm.com> (sfid-20140325_090104_513870_7A3B8C2D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Driver is supposed to call it only once for each
> scheduled channel_switch_beacon().
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
> This is required for multi-vif csa but since that
> isn't merged yet I'm not including any specifics
> in the commit log itself.
>
> Preventing multiple ieee80211_csa_finish() calls
> sounds like a good idea in general to me.

Based on the discussion I'm dropping this. Please resend if we actually
want to have this in ath10k.

-- 
Kalle Valo
