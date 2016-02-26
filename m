Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44238 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbcBZKyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 05:54:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Fengguang Wu <lkp@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211_hwsim: treat as part of mac80211 for MAINTAINERS
References: <1456480234-5888-1-git-send-email-johannes@sipsolutions.net>
Date: Fri, 26 Feb 2016 12:54:17 +0200
In-Reply-To: <1456480234-5888-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Fri, 26 Feb 2016 10:50:34 +0100")
Message-ID: <87lh67n3mu.fsf@purkki.adurom.net> (sfid-20160226_115428_940907_C20CDA54)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Since I maintain this driver as part of mac80211, add it to
> the file list for mac80211; this helps submitters send it to
> me instead of Kalle and also makes the build robot apply the
> patches for it on the right tree for build attempts.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

FWIW:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
