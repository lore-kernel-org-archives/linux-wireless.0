Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52809 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab0ADQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 11:37:09 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] cfg80211: add regulatory hint disconnect support
Date: Mon, 4 Jan 2010 17:37:04 +0100
Cc: linux-wireless@vger.kernel.org
References: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1262622502-27698-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001041737.06761.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 January 2010 17:28:22 Luis R. Rodriguez wrote:

> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index c2a2c56..ae58c6a 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -580,6 +580,7 @@ void wiphy_unregister(struct wiphy *wiphy)
>  
>  	flush_work(&rdev->scan_done_wk);
>  	cancel_work_sync(&rdev->conn_work);
> +	cancel_work_sync(&rdev->conn_work);
>  	flush_work(&rdev->event_work);
>  }

twice?

-- 
Greetings, Michael.
