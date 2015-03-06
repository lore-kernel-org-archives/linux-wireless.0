Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42619 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbbCFKzv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 05:55:51 -0500
Message-ID: <1425639348.3339.2.camel@sipsolutions.net> (sfid-20150306_115601_047410_F15682FE)
Subject: Re: [RFC v2] [RFC] mac80211: lock rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Date: Fri, 06 Mar 2015 11:55:48 +0100
In-Reply-To: <2736671.Y6Lt54SxyK@bentobox> (sfid-20150306_114752_555961_0571F3D8)
References: <1425575237-5556-1-git-send-email-johannes@sipsolutions.net>
	 <2736671.Y6Lt54SxyK@bentobox> (sfid-20150306_114752_555961_0571F3D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-03-06 at 11:47 +0100, Sven Eckelmann wrote:

> The function rate_control_rate_init is called by the IBSS code (in my OpenWrt 
> compat-wireless 2014-11-04 snapshot) in ieee80211_ibss_finish_sta and 
> ieee80211_rx_bss_info after an rates_updated. At least the latter one sounds 
> suspicious.

Yeah, I forgot IBSS is doing strange things here.

> I will just add following modification to your patch and ask for a new test. 

Let me know how that goes :)

johannes

