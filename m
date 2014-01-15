Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaAON2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 08:28:00 -0500
Message-ID: <1389792475.4338.11.camel@jlt4.sipsolutions.net> (sfid-20140115_142802_974101_E5FD2A11)
Subject: Re: [RFC 2/2] cfg80211: DFS get CAC time from regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Wed, 15 Jan 2014 14:27:55 +0100
In-Reply-To: <1389788210-7246-2-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140115_131704_469508_0B919594)
References: <1389788210-7246-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1389788210-7246-2-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140115_131704_469508_0B919594)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 13:16 +0100, Janusz Dziedzic wrote:

> @@ -3211,6 +3212,7 @@ struct wireless_dev {
>  
>  	bool cac_started;
>  	unsigned long cac_start_time;
> +	unsigned int cac_time_ms;

Why would that need to be stored here? Isn't it just a pretty much local
parameter of the radar detection startup?

johannes

