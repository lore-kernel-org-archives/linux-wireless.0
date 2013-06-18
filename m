Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3FRO1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:27:10 -0400
Message-ID: <1371565626.8318.26.camel@jlt4.sipsolutions.net> (sfid-20130618_162725_009615_0760E8FB)
Subject: Re: [PATCHv3 07/18] mac80211: add radiotap flag and handling for
 5/10 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Tue, 18 Jun 2013 16:27:06 +0200
In-Reply-To: <1368702045-27598-8-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368702045-27598-8-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 13:00 +0200, Simon Wunderlich wrote:

> Wireshark

doesn't really matter all that much, but I guess the radiotap standard
also defines it.


> +	RX_FLAG_10MHZ			= BIT(26),
> +	RX_FLAG_5MHZ			= BIT(27),

Does that make sense? We know what kind of channel we're on? Though it
might be easier for the driver, so it may make sense I guess.

johannes

