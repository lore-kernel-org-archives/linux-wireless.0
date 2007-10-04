Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:38872 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbXJDEKc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 00:10:32 -0400
Date: Wed, 3 Oct 2007 21:09:57 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: adjust for changed nl80211
Message-ID: <20071004040957.GM933@jm.kir.nu> (sfid-20071004_051036_779814_CB26D0EF)
References: <1191069453.22960.77.camel@johannes.berg> <20071003030951.GH933@jm.kir.nu> <1191393995.4178.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191393995.4178.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 03, 2007 at 08:46:35AM +0200, Johannes Berg wrote:
> On Tue, 2007-10-02 at 20:09 -0700, Jouni Malinen wrote:
> > I did not find this change from wireless-dev.git#everything.. Am I
> > missing something or has this not been applied to the kernel yet?
> 
> You missed that wireless-dev is dead and we're using
> wireless-2.6#everything now.

OK. Though, hostapd does not build at all against that due to
net/mac80211/hostapd_ioctl.h not existing.. Anyway, with a copy of
previous version of this file, I can build driver_devicescape.c and see
the change in include/linux/nl80211.h. I applied your patch to changing
the nl80211 commands for new/del interface.

-- 
Jouni Malinen                                            PGP id EFC895FA
