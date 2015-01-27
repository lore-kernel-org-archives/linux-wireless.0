Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42788 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626AbbA0JPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 04:15:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: use IEEE80211_HW_SW_CRYPTO_CONTROL
In-Reply-To: <1421959125-10834-2-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Thu, 22 Jan 2015 21:38:45 +0100")
References: <1421959125-10834-1-git-send-email-johannes@sipsolutions.net>
	<1421959125-10834-2-git-send-email-johannes@sipsolutions.net>
Date: Tue, 27 Jan 2015 11:15:00 +0200
Message-ID: <874mrcega3.fsf@kamboji.qca.qualcomm.com> (sfid-20150127_101513_845932_B4F4F3AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> The ath10k driver only supports HW crypto (except for management
> frames or so - CMAC needs to be done in software). Make it use
> the new IEEE80211_HW_SW_CRYPTO_CONTROL flag to ensure mac80211
> doesn't erroneously attempt to use software crypto.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Feel free to take this via your tree.

-- 
Kalle Valo
