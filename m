Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:42558 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbXEZRzm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 13:55:42 -0400
Message-ID: <46587492.6070106@lwfinger.net>
Date: Sat, 26 May 2007 12:55:30 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix for tx_bias equal to 0xFF
References: <465869ce.8wcEX9q9ZmHxX2m3%Larry.Finger@lwfinger.net> <200705261919.39143.mb@bu3sch.de>
In-Reply-To: <200705261919.39143.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> Ok, on which specification bits is this actually based? :)
> txpower_bg still needs a rewrite, and I have a patch for that in
> the pipeline, but it's still buggy due to missing specs stuff.
> 

It is not in the V4 specifications that I have found, but the V3 (softmac) driver does this "fixup". 
With it, my 4311 connects with bcm43xx-mac80211. Without it, no connection.

Larry


