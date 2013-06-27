Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48806 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab3F0NMl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 09:12:41 -0400
Message-ID: <1372338757.8160.9.camel@jlt4.sipsolutions.net> (sfid-20130627_151244_435221_5359F1CA)
Subject: Re: [PATCHv4 08/18] mac80211: allow scanning for 5/10 MHz channels
 in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 15:12:37 +0200
In-Reply-To: <1372337064-19254-9-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-9-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

> +	case NL80211_BSS_CHAN_WIDTH_20:
> +		/* If scanning on oper channel, use whatever channel-type
> +		 * is currently in use.
> +		*/

That seems to be missing a space :)
You also moved the code, but didn't delete the comment in its original
place?

johannes

