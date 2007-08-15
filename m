Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:40872 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbXHODuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 23:50:11 -0400
Date: Tue, 14 Aug 2007 20:49:09 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] hostapd: remove enable/disable calls
Message-ID: <20070815034909.GL1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net> <20070814093408.541566000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070814093408.541566000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2007 at 11:32:55AM +0200, Johannes Berg wrote:
> This isn't really useful since mac80211 always enables the radio
> when the interface is brought up.

Thanks, applied. I think this parameter was originally used (with
another name, though) for disabling the radio when a radar was detected.
The benefit of being able to do this without bringing down the interface
was to not lose IP configuration. Anyway, the radar stuff is very likely
to take a different direction, so getting rid of this parameter should
be fine.

-- 
Jouni Malinen                                            PGP id EFC895FA
