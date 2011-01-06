Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1AFVEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:04:45 -0500
Subject: Re: Question about iwl3945
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4D262CED.5070409@lwfinger.net>
References: <4D262CED.5070409@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 22:04:41 +0100
Message-ID: <1294347881.25228.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-06 at 14:58 -0600, Larry Finger wrote:
> Is there any reason why the Intel3495 wireless card using the iwl3945 driver
> with kernel 2.6.34 does not work in AP mode using hostapd? The message is
> 
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.

Neither 3945 nor 4965 can ever support AP mode due to firmware
restrictions, sorry.

johannes

