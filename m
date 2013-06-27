Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3F0NGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:06:35 -0400
Message-ID: <1372338392.8160.4.camel@jlt4.sipsolutions.net> (sfid-20130627_150642_720896_9CC6B500)
Subject: Re: [PATCHv4 03/18] mac80211: fix timing for 5 MHz and 10 MHz
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 15:06:32 +0200
In-Reply-To: <1372337064-19254-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

> +static inline int
> +ieee80211_local_get_divisor(struct ieee80211_local *local)
> +{
> +	if (local->use_chanctx)
> +		return 1;

Why this?

johannes

