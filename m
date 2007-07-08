Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:56381 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbXGHUDE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 16:03:04 -0400
Received: from ananke.telenet-ops.be (ananke.telenet-ops.be [195.130.137.78])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id EC5E89CFE3
	for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2007 22:03:01 +0200 (CEST)
Message-ID: <469142CC.1000903@telenet.be>
Date: Sun, 08 Jul 2007 22:02:20 +0200
From: ian <ischram@telenet.be>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi 3945: secondary interface disallows association
References: <4691310E.8070406@warmcat.com>
In-Reply-To: <4691310E.8070406@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't appear to have the same problem with:
  -latest version of iwlwifi (0.0.35)
  - gentoo-sources-2.6.20 kernel (patched with a relatively old mac80211 package)

I believe fedora has 0.0.24 of iwlwifi embedded?
So the problem might have been fixed already.

Writing this email, after executing your command, when associated on a wpa2
network.

Ian.

Andy Green wrote:
> Hi folks -
> 
> I have pretty decent functionality on the 3945abg laptop with the Fedora
> development kernel version of iwlwifi and WPA via wpa_supplicant.
> Connections can stay up over a couple of days or more when I am staying
> close to the AP.
> 
> However if I perform this action:
> 
> echo -n mon0 > /sys/class/ieee80211/phy0/add_iface
> 
> I immediately lose association and cannot reacquire it until I remove
> the iwl3945 module and insert again.  I don't have to do anything with
> the new interface, just create it.  I tried setting the channel and mode
> of it, but that didn't help with reacquiring an association.
> 
> In contrast I can bring up other virtual interfaces okay on, eg, zd1211
> without losing an existing association to the same WPA network.
> 
> -Andy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
