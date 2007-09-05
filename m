Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:55281 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXIECkv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 22:40:51 -0400
Date: Tue, 4 Sep 2007 19:40:37 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: remove key threshold setting
Message-ID: <20070905024037.GF5273@jm.kir.nu>
References: <1187957890.24933.24.camel@johannes.berg> <20070904002758.GW1835@jm.kir.nu> <1188917221.9942.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188917221.9942.35.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 04:47:01PM +0200, Johannes Berg wrote:
> On Mon, 2007-09-03 at 17:27 -0700, Jouni Malinen wrote:
> > On Fri, Aug 24, 2007 at 02:18:10PM +0200, Johannes Berg wrote:
> > > I'm in the process of adding this to nl80211 as a per-key setting, so
> > > remove it here for now. It's never called anyway.
> > 
> > Thanks, applied.
> 
> Looks like you didn't push that out to your git tree.

Yes, apparently I forgot to push the last change out. Anyway, it was
applied at that time ;-) and is now on w1.fi.

-- 
Jouni Malinen                                            PGP id EFC895FA
