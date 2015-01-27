Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60614 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbA0KM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 05:12:29 -0500
Message-ID: <1422353545.1890.57.camel@sipsolutions.net> (sfid-20150127_111232_644427_75422345)
Subject: Re: [PATCH 2/2] ath10k: use IEEE80211_HW_SW_CRYPTO_CONTROL
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 11:12:25 +0100
In-Reply-To: <874mrcega3.fsf@kamboji.qca.qualcomm.com>
References: <1421959125-10834-1-git-send-email-johannes@sipsolutions.net>
	 <1421959125-10834-2-git-send-email-johannes@sipsolutions.net>
	 <874mrcega3.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-27 at 11:15 +0200, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > The ath10k driver only supports HW crypto (except for management
> > frames or so - CMAC needs to be done in software). Make it use
> > the new IEEE80211_HW_SW_CRYPTO_CONTROL flag to ensure mac80211
> > doesn't erroneously attempt to use software crypto.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Feel free to take this via your tree.

Thanks Kalle. I've put it into my tree to unblock Jouni's crypto
patches.

johannes


