Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60014 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbbAONF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 08:05:57 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco/hermes: select CFG80211_WEXT
References: <1420548417-17650-1-git-send-email-johannes@sipsolutions.net>
Date: Thu, 15 Jan 2015 15:05:50 +0200
In-Reply-To: <1420548417-17650-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Tue, 6 Jan 2015 13:46:57 +0100")
Message-ID: <87y4p4qjm9.fsf@kamboji.qca.qualcomm.com> (sfid-20150115_140602_304833_FA1B1362)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> It makes no sense to require the user to find and enable
> CFG80211_WEXT before the driver can be selected, make the
> driver select the needed Kconfig symbol itself.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
