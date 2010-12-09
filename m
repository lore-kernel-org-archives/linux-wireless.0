Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2657 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab0LIROm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 12:14:42 -0500
Date: Thu, 9 Dec 2010 12:00:40 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>, nbd@openwrt.org
Subject: Re: ath5k: Weird Retransmission Behaviour
Message-ID: <20101209170040.GA24840@hash.localnet>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <201012061714.15863.br1@einfach.org> <AANLkTi=+bZbsZXR2v1AUKLEEAWGLpq-uNJXQ13t-Bf+D@mail.gmail.com> <AANLkTimwprBJpnLM6_Qap1wSVboVJPQecAUgmzAnQhu-@mail.gmail.com> <AANLkTim5hESSHAMYNryUwak=D4tQetZJuDEK41Yq3A+L@mail.gmail.com> <20101209123841.GA31566@hash.localnet> <AANLkTinmsG9NhiiigOrFZQUS+pdDaHSvxpN7JnjdUXs=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTinmsG9NhiiigOrFZQUS+pdDaHSvxpN7JnjdUXs=@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 12:34:19AM +1000, Jonathan Guerin wrote:
> > For what it's worth, I tested pid and minstrel a while ago with a
> > modified mac80211_hwsim, and found minstrel to be quite a bit better
> > at rate adaptation.  So while it may be worth testing out for this
> > particular use case, minstrel is probably the way to go in general.
> 
> So, while I say this with no idea how to do it, might it be worth
> fixing Minstrel so that it adheres to mac80211's maximum retry values?
 
Yeah, so that's what the linked patch I posted tries to do :)

-- 
Bob Copeland %% www.bobcopeland.com

