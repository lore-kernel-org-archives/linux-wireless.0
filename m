Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:33798 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbXJCDKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 23:10:21 -0400
Date: Tue, 2 Oct 2007 20:09:51 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: adjust for changed nl80211
Message-ID: <20071003030951.GH933@jm.kir.nu> (sfid-20071003_041026_555573_FA819AD1)
References: <1191069453.22960.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191069453.22960.77.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 29, 2007 at 02:37:33PM +0200, Johannes Berg wrote:
> Before pushing nl80211 into mainline I cleaned it up
> and made it more object oriented. This led to a rename
> of some things hostapd is already using, so it needs
> to be adjusted.

>  hostapd/driver_devicescape.c |    4 ++--
>  	genlmsg_put(msg, 0, 0, genl_family_get_id(drv->nl80211), 0,
> -		    0, NL80211_CMD_DEL_VIRTUAL_INTERFACE, 0);
> +		    0, NL80211_CMD_DEL_INTERFACE, 0);

I did not find this change from wireless-dev.git#everything.. Am I
missing something or has this not been applied to the kernel yet?

-- 
Jouni Malinen                                            PGP id EFC895FA
