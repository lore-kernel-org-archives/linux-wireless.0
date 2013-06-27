Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48766 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3F0M6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 08:58:05 -0400
Message-ID: <1372337877.8160.2.camel@jlt4.sipsolutions.net> (sfid-20130627_145811_968501_4BB94237)
Subject: Re: [PATCHv4 01/18] nl80211: add scan width to bss and scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 27 Jun 2013 14:57:57 +0200
In-Reply-To: <1372337064-19254-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1372337064-19254-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1372337064-19254-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-27 at 14:44 +0200, Simon Wunderlich wrote:

> + * @NL80211_BSS_CHAN_WIDTH_20: control channel is 20 MHz wide or compatible
> + * @NL80211_BSS_CHAN_WIDTH_10: control channel is 10 MHz wide
> + * @NL80211_BSS_CHAN_WIDTH_5: control channel is 10 MHz wide

copy/paste error

This also looks incomplete? You say you add it to scan but didn't
really?

johannes

