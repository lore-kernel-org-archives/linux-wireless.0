Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58029 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbcFIKmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 06:42:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: Re: [PATCH 4/6] ath9k: Expose tsf_adjustment in mac80211 tsf getters and setters.
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
	<1465305001-26067-4-git-send-email-benjamin@sipsolutions.net>
Date: Thu, 09 Jun 2016 13:42:02 +0300
In-Reply-To: <1465305001-26067-4-git-send-email-benjamin@sipsolutions.net>
	(Benjamin Berg's message of "Tue, 7 Jun 2016 15:09:59 +0200")
Message-ID: <87bn3aiqyt.fsf@kamboji.qca.qualcomm.com> (sfid-20160609_124213_771964_69F00150)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> writes:

> From: Benjamin Berg <benjamin.berg@open-mesh.com>
>
> Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>

Why? Does this help with mesh or what?

Remember that the most important part of the commit log is to answer the
question "Why?".

-- 
Kalle Valo
