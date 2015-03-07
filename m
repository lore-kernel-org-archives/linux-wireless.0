Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46985 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbbCGHqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 02:46:13 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: fix AP/IBSS CSA with template based fw
References: <1423749198-11346-1-git-send-email-michal.kazior@tieto.com>
	<1424090094-28164-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 09:46:03 +0200
In-Reply-To: <1424090094-28164-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 16 Feb 2015 13:34:54 +0100")
Message-ID: <87mw3p1c90.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_084617_962415_790058BB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> qca6174 with wmi-tlv firmware uses offloaded
> beaconing scheme (i.e. templates). This requires a
> little different approach when implementing CSA.
>
> Add missing code to update CS count and report CSA
> completion to mac80211. Without it channel switch
> was never finished.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
