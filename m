Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:38711 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYFLSKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 14:10:54 -0400
Received: by py-out-1112.google.com with SMTP id p76so1717225pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2008 11:10:53 -0700 (PDT)
Subject: Re: [RFC] Do not activate promiscuous mode on wlan interfaces for
	bridging.
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, shemminger@linux-foundation.org,
	johannes@sipsolutions.net, bridge@linux-foundation.org,
	Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <20080612053323.GC4919@jm.kir.nu>
References: <1213232760.6645.24.camel@localhost>
	 <20080612053323.GC4919@jm.kir.nu>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 11:10:50 -0700
Message-Id: <1213294251.6615.5.camel@localhost> (sfid-20080612_201057_784803_4123D964)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much for your comments Jouni.

On Thu, 2008-06-12 at 08:33 +0300, Jouni Malinen wrote:
> Whether the "promiscuous mode" is really a suitable name for this mode
> is another question, though, since there are more ways to be
> promiscuous in wireless networks than wired.. ;-)

Indeed, but the bridge sets promiscuous mode, not monitor. This means
that the device will receive every frame within its configured BSS
whether it is addressed to it or not. For an AP actually this mode
should make no difference, since every frame not coming from the AP is
addressed to the AP.


> This is not strictly speaking correct. 4-address frame format (WDS) can
> be used in other (non-AP) modes, too. Anyway, they do not require the
> interface to be in promiscuous mode since addr1 of the frames is the
> unicast address of the receiving device regardless of the original
> destination address.

Agreed, will reword that.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


