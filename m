Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55364 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbdBMHGP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Feb 2017 02:06:15 -0500
Message-ID: <1486969571.5142.3.camel@sipsolutions.net> (sfid-20170213_080620_524234_F34F335B)
Subject: Re: VHT 160Mhz and nss related config.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
Date: Mon, 13 Feb 2017 08:06:11 +0100
In-Reply-To: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com> (sfid-20170210_235835_296103_8149499F)
References: <0082a9e3-83f3-9bc3-af43-b890b91cfd93@candelatech.com>
         (sfid-20170210_235835_296103_8149499F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-02-10 at 14:58 -0800, Ben Greear wrote:
> So, it appears that the ath10k QCA9984 4x4 160Mhz chip can do 4x4
> MIMO at VHT80, but
> it can do only 2x2 MIMO at VHT160/80+80.
> 
> When configuring a peer, we need to tell the firmware the number of
> spatial streams
> of the peer at VHT160 and at VHT80 and lower.  They are not the same
> value.
> 
> I cannot think of any standard way to get this information based on
> VHT capabilities and such.  Currently, one could just assume VHT160
> NSS is 1/2 of the VHT80 NSS, but that is unlikely to be true for all
> vendors.

This was recently added to the VHT capabilities in the spec, see Table
9-250 in 802.11-2016.

johannes
