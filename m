Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54075 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaBLWwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 17:52:03 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: Re: [PATCH 4/9] Cache nv to avoid request_firmware on resume path
References: <1392231888-2191-1-git-send-email-k.eugene.e@gmail.com>
	<1392231888-2191-4-git-send-email-k.eugene.e@gmail.com>
Date: Thu, 13 Feb 2014 00:51:59 +0200
In-Reply-To: <1392231888-2191-4-git-send-email-k.eugene.e@gmail.com> (Eugene
	Krasnikov's message of "Wed, 12 Feb 2014 19:04:43 +0000")
Message-ID: <87fvnokkq8.fsf@purkki.adurom.net> (sfid-20140212_235208_461324_CB5C82F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eugene Krasnikov <k.eugene.e@gmail.com> writes:

> From: Pontus Fuchs <pontus.fuchs@gmail.com>
>
> If wowlan if off mac80211 will stop / start the driver on suspend /
> resume. This causes problems on resume since request_firmware is called
> from start. Fix this by caching the nv.
>
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>

"wcn36xx:" prefix missing.

-- 
Kalle Valo
