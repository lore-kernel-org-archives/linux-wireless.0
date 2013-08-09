Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39152 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967216Ab3HINUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:20:17 -0400
Message-ID: <1376054413.8355.9.camel@jlt4.sipsolutions.net> (sfid-20130809_152021_622696_572F88BA)
Subject: Re: [PATCH 3/7] mac80211: split off channel switch parsing function
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 09 Aug 2013 15:20:13 +0200
In-Reply-To: <1375457886-7275-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1375457886-7275-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-02 at 17:38 +0200, Simon Wunderlich wrote:

>  		sdata_info(sdata,
> +			   "network switches to unsupported channel (%d MHz), disconnecting\n",
> +			   new_freq);
> +		return -EINVAL;

I don't like these messaging changes - it's actually interesting what
the AP is etc.

johannes

