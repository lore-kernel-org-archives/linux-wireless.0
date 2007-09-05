Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:41123 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbXIECzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 22:55:22 -0400
Date: Tue, 4 Sep 2007 19:55:08 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
Message-ID: <20070905025508.GH5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg> <20070904011648.GX1835@jm.kir.nu> <1188913335.9942.16.camel@johannes.berg> <1188917716.9942.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188917716.9942.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 04:55:16PM +0200, Johannes Berg wrote:

> Also, since this affects git trees only... To use this you actually have
> to have hostap git, wireless-dev git so what's the big deal with
> requiring libnl svn? :)

In my particular case, one of the main problems was in svn not working
after libexpat update on Gentoo.. ;-)  This made it a bit difficult to
fetch the correct version.

At this point, we are indeed talking about quite bleeding edge stuff,
but I'm planning on releasing hostapd 0.6.1 at some point soonish and I
would hope that mainline Linux kernel will get enough stuff for at least
minimal AP functionality and at that point, I do not really want to
point people at an svn repository as the only means of getting a
required library..

-- 
Jouni Malinen                                            PGP id EFC895FA
