Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32976 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbcANJUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 04:20:53 -0500
Message-ID: <1452763246.2444.0.camel@sipsolutions.net> (sfid-20160114_102101_362286_FF7B5DED)
Subject: Re: [RFC V2 0/3] nl80211: allow configuration of BSS selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Date: Thu, 14 Jan 2016 10:20:46 +0100
In-Reply-To: <5697671B.2040302@broadcom.com>
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <5697671B.2040302@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-14 at 10:15 +0100, Arend van Spriel wrote:
> 
> I looked into the suggested mac80211 "demo", but it seems this bss 
> selection could be handled in net/wireless/sme.c for drivers support 
> .assoc() and friends instead of .connect(). However, I recall Jouni 
> suggesting to have NL80211_ATTR_BSS_SELECT in NL80211_CMD_ASSOC as
> well. 
> So I guess wpa_s uses that command directly?
> 

wpa_s uses assoc(), yeah. This would only be relevant if you actually
used "iw wlan0 connect", but still might be worthwhile as an example?
Dunno.

johannes
