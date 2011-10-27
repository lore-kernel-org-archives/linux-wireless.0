Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1J0ThG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 15:37:06 -0400
Subject: Re: Re: [PATCH 2/2] iw: show STA flags in station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Arik Nemtsov <anamtsov@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4758903.33HQxio52G@helmutmobil.site> (sfid-20111018_192557_977316_266036F5)
References: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com>
	 <1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com>
	 <CA+XVXfdKPdwXubpnX50zJRCXaxHpubAd3tDgWrCnQQggXKKhPQ@mail.gmail.com>
	 <4758903.33HQxio52G@helmutmobil.site>
	 (sfid-20111018_192557_977316_266036F5)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 21:37:03 +0200
Message-ID: <1319744223.32221.5.camel@jlt3.sipsolutions.net> (sfid-20111027_213710_585870_97115AA2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 19:23 +0200, Helmut Schaa wrote:
> Am Dienstag, 18. Oktober 2011, 18:41:11 schrieb Arik Nemtsov:
> > On Tue, Oct 18, 2011 at 11:18, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> > >
> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > > ---
> > >
> > > Couldn't come up with a nice/short wording for "Managment frame
> > > protection" and "Wireless Multimedia Extension" so I just used MFP
> > > and WME/WMM instead.
> > >
> > 
> > Printing the NL80211_STA_FLAG_TDLS_PEER flag would be nice as well.
> 
> Agreed, I somehow missed the (new) TDLS flag, also in the according
> nl80211/mac80211 patches :(

I'll apply this to iw fixed up but please send patches to the kernel.

johannes

