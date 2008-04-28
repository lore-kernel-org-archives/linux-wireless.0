Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:64248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764962AbYD1I3d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 04:29:33 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7848541waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2008 01:29:33 -0700 (PDT)
Message-ID: <1ba2fa240804280129r48762639jac501a3010e132a6@mail.gmail.com> (sfid-20080428_102941_011231_99E0EC18)
Date: Mon, 28 Apr 2008 11:29:32 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] Fix compile error with wifi & leds
Cc: "Luca Tettamanti" <kronos.it@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"Priit Laes" <plaes@plaes.org>
In-Reply-To: <20080428082030.GD16379@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080426203408.GA12074@dreamland.darkstar.lan>
	 <20080428074531.GA16379@cs181133002.pp.htv.fi>
	 <20080428075452.GB16379@cs181133002.pp.htv.fi>
	 <1ba2fa240804280118l5f813b38n8291789342b1d802@mail.gmail.com>
	 <20080428082030.GD16379@cs181133002.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 28, 2008 at 11:20 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Mon, Apr 28, 2008 at 11:18:08AM +0300, Tomas Winkler wrote:
>  > On Mon, Apr 28, 2008 at 10:54 AM, Adrian Bunk <bunk@kernel.org> wrote:
>  > > On Mon, Apr 28, 2008 at 10:45:31AM +0300, Adrian Bunk wrote:
>  > >  > Can you send the .config that gives this problem?
>  > >
>  > >  Scrap that, I already got the problem (and your patch looks right).
>  > >
>  > >
>  >
>  > I think it's time to be applied so we won't get another 5 of them.
>  > Please add also  Priit Laes <plaes@plaes.org>  as he was first to
>  > provide a patch
>
>  David already sent a pull request that includes Luca's patch to Linus.
>
>  My question was due to me first misunderstanding what's happening here.
>
I see... I wasn't subscribed so I missed that.
Anyhow what is happening is that I've assumed that 'select' is
transitive and selecting MAC80211_LEDs is enough.

Tomas
