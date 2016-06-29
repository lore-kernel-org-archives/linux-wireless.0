Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbcF2QEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 12:04:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: reconfigure sta rates on authorization
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1466345338-31972-1-git-send-email-guym@ti.com>
To: Guy Mishol <guym@ti.com>
Cc: <linux-wireless@vger.kernel.org>, Guy Mishol <guym@ti.com>
Message-Id: <20160629160331.BA49560159@smtp.codeaurora.org> (sfid-20160629_180415_255645_2775D465)
Date: Wed, 29 Jun 2016 16:03:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guy Mishol <guym@ti.com> wrote:
> Since stations can now be added before association
> (NL80211_FEATURE_FULL_AP_CLIENT_STATE support),
> no supported rates are set when the station is added
> to the fw, resulting in fw recovery.
> 
> Fix it by first configuring the AP basic rates as
> the station configured rates (when the station is
> first added to the driver), and after the station
> was authorized re-configure it, now with the actual
> supported rates.
> 
> Signed-off-by: Guy Mishol <guym@ti.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

535633a5ba4e wlcore: reconfigure sta rates on authorization

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9186155/

