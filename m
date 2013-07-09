Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3GIPIk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 11:08:40 -0400
Message-ID: <1373382510.8241.2.camel@jlt4.sipsolutions.net> (sfid-20130709_170843_315266_A28EA370)
Subject: Re: [PATCHv6 00/18] Add support for 5 and 10 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 09 Jul 2013 17:08:30 +0200
In-Reply-To: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373295366-12823-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-08 at 16:55 +0200, Simon Wunderlich wrote:
> This patchset adds support for 5 and 10 MHz in nl80211/cfg80211/mac80211
> and enables support in ath5k and ath9k, which already support this feature
> on the driver side. 5 and 10 MHz wide channels might be useful for:
> 
>  * long shot links, as the transmissions are more robust
>  * future support for 802.11y which allows some 5 and 10 MHz channels in
>    3.6 GHz range
>  * future support for 802.11p which uses 10 MHz in 5.9 GHz range
>  * ... and more "special" applications.
> 
> This patchset enables 5 and 10 MHz channels only for OFDM, and without
> HT/MIMO/aggregation (for now). Support may be added later.

I've applied patches 1-10, not going to take the ath patches.

johannes

