Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:59655 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZHTGjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 02:39:11 -0400
Message-ID: <20090820093910.15951ic8206lztz4@naisho.dyndns.info>
Date: Thu, 20 Aug 2009 09:39:10 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: Dave <kilroyd@googlemail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] cfg80211: scan before connect if we don't have the
	bss
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
	<1250640253-18434-6-git-send-email-kilroyd@googlemail.com>
	<1250668113.16393.25.camel@johannes.local> <4A8C52BD.5070609@gmail.com>
In-Reply-To: <4A8C52BD.5070609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dave <kilroyd@googlemail.com>:

>
> Another alternative is for cfg80211_connect_result to trigger the scan
> if it doesn't have the bss, and only complete the connect when the scan
> returns. I think I like the sound of this best.
>

This sounds best, as with rndis, driver can get currently connected  
bss from device and scan isn't required.

-Jussi

