Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KRLRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 06:17:52 -0500
Subject: Re: [PATCHv3 2/3] wireless: Add NoAck per tid Support
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
In-Reply-To: <1321614110-32392-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1321614110-32392-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1321614110-32392-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 12:17:48 +0100
Message-ID: <1321615068.10266.47.camel@jlt3.sipsolutions.net> (sfid-20111118_121755_205588_0BE54442)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 12:01 +0100, Simon Wunderlich wrote:

> + * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
> + *      No Acknowledgement Policy should be applied.
> + *

Please advertise this in nl80211_send_wiphy().

Otherwise looks good to me, much easier to understand than before :-)

johannes

