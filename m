Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62458 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1JRRZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 13:25:27 -0400
Received: by eye27 with SMTP id 27so786553eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 10:25:26 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Re: [PATCH 2/2] iw: show STA flags in station dump
Date: Tue, 18 Oct 2011 19:23:30 +0200
Message-ID: <4758903.33HQxio52G@helmutmobil.site> (sfid-20111018_192530_975844_3E04D71A)
In-Reply-To: <CA+XVXfdKPdwXubpnX50zJRCXaxHpubAd3tDgWrCnQQggXKKhPQ@mail.gmail.com>
References: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com> <1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com> <CA+XVXfdKPdwXubpnX50zJRCXaxHpubAd3tDgWrCnQQggXKKhPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 18. Oktober 2011, 18:41:11 schrieb Arik Nemtsov:
> On Tue, Oct 18, 2011 at 11:18, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> >
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> >
> > Couldn't come up with a nice/short wording for "Managment frame
> > protection" and "Wireless Multimedia Extension" so I just used MFP
> > and WME/WMM instead.
> >
> 
> Printing the NL80211_STA_FLAG_TDLS_PEER flag would be nice as well.

Agreed, I somehow missed the (new) TDLS flag, also in the according
nl80211/mac80211 patches :(

Thanks,
Helmut
