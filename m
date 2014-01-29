Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42341 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaA2Mpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:45:54 -0500
Message-ID: <1390999550.4143.9.camel@jlt4.sipsolutions.net> (sfid-20140129_134601_507186_32915F8C)
Subject: Re: [PATCH] mac80211: send ibss probe responses with noack flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <simon@open-mesh.com>
Date: Wed, 29 Jan 2014 13:45:50 +0100
In-Reply-To: <1390603709-8041-1-git-send-email-sw@simonwunderlich.de>
References: <1390603709-8041-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-24 at 23:48 +0100, Simon Wunderlich wrote:
> From: Simon Wunderlich <simon@open-mesh.com>
> 
> Responding to probe requests for scanning clients will often create
> excessive rtries, as it happens quite often that the scanning client
> already left the channel. Therefore do it like hostapd and send probe
> responses for broadcast SSID only once by using the noack flag.

Applied. Should have said "wildcard" though, technically :)

johannes

