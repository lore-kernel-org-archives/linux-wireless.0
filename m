Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:60788 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbXHUDKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 23:10:33 -0400
Date: Mon, 20 Aug 2007 20:09:18 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/20] mac80211: remove unused ioctls (1)
Message-ID: <20070821030918.GM1415@jm.kir.nu>
References: <20070815144920.135826000@sipsolutions.net> <20070815145043.551508000@sipsolutions.net> <20070818040423.GF1415@jm.kir.nu> <1187601005.6090.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187601005.6090.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2007 at 11:10:05AM +0200, Johannes Berg wrote:
> On Fri, 2007-08-17 at 21:04 -0700, Jouni Malinen wrote:

> > First one
> > is useful should one be interested in WFA certifications tests. 
> 
> That should, imho, rather live in debugfs. Somebody doing certification
> tests ought to be able to enable debugfs on their system.

Sure, that's fine. I was mainly objecting for the part of completely
removing the code (i.e., not just the ioctl). I don't really care how
this command goes through, but anyway, I would agree that debugfs would
be more reasonable location now that it is available and already being
used elsewhere in mac80211.

> > Scan
> > flags can be useful in filtering out scan results in cases where there
> > are huge numbers of APs around. 
> 
> Plan has it that the new cfg80211 API for scanning allows scanning for
> things rather than filtering the results after the fact, e.g. (like
> iwlist already supports) scanning for a particular SSID. I suppose
> hardware designs like iwlwifi could make much better use of that than
> mac80211 itself though.

OK. I was more commenting on part of removing functionality, not on the
removal of ioctl itself.

-- 
Jouni Malinen                                            PGP id EFC895FA
