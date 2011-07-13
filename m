Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45558 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab1GMODE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 10:03:04 -0400
Received: by qyk29 with SMTP id 29so313918qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2011 07:03:02 -0700 (PDT)
Message-ID: <4E1DA593.4020401@lwfinger.net> (sfid-20110713_160307_871728_D41743C7)
Date: Wed, 13 Jul 2011 09:02:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] b43legacy: remove wireless extensions inclusions
References: <20110713083908.713123063@sipsolutions.net> <20110713084033.380526262@sipsolutions.net>
In-Reply-To: <20110713084033.380526262@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 03:39 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> linux/wireless.h and net/iw_handler.h headers are
> for wireless extensions only, so mac80211 drivers
> shouldn't be including them.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
> ---
>   drivers/net/wireless/b43legacy/b43legacy.h |    1 -
>   drivers/net/wireless/b43legacy/main.c      |    1 -
>   2 files changed, 2 deletions(-)

ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>

