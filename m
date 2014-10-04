Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:35491 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbaJDNJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2014 09:09:03 -0400
Date: Sat, 4 Oct 2014 16:08:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Ben Greear <greearb@candelatech.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Support for bitrate-mask in wpa_supplicant?
Message-ID: <20141004130858.GB2987@w1.fi> (sfid-20141004_150909_224420_F6679960)
References: <542D87F6.8090306@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <542D87F6.8090306@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2014 at 10:14:30AM -0700, Ben Greear wrote:
> From what I can tell, wpa_supplicant does not have a way to set
> the tx-bitrate-mask, except for some code
> to disable 802.11b rates (which I think will in turn (re)enable all
> of the other rates that may have previously been disabled.
> 
> So, would it be worthwhile to add support to supplicant to at
> least configure the legacy rates using the NL80211_CMD_SET_TX_BITRATE_MASK
> netlink message?

Why would wpa_supplicant be involved in that? What kind of use case
would benefit from this (vs. setting this through iw, for example)?

-- 
Jouni Malinen                                            PGP id EFC895FA
