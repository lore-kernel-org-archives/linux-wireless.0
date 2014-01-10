Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8754 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaAJKWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jan 2014 05:22:20 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add support for AP CSA
References: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 10 Jan 2014 12:22:14 +0200
In-Reply-To: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Jan 2014 10:19:23 +0100")
Message-ID: <87d2k09lwp.fsf@kamboji.qca.qualcomm.com> (sfid-20140110_112224_217179_E3E47D43)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This patch implements Channel Switch Announcement
> for AP mode. This allows for a smooth channel
> switch for connected stations that support CSA
> when radar is detected.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I had few conflicts while applying to ath-next-test (the branch for
pending patches). Please double check my changes:

https://github.com/kvalo/ath/commit/c7bb77f4bf9986e6be4b522ba1e01cd78ebb66af

-- 
Kalle Valo
