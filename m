Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2182 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbZHVNlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 09:41:02 -0400
Date: Sat, 22 Aug 2009 09:40:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
Message-ID: <20090822134044.GC6762@hash.localnet>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com> <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com> <b6c5339f0908210719o2323d590w4a9f6a01d5ecb2d6@mail.gmail.com> <20090822124709.GA6762@hash.localnet> <b637ec0b0908220602v3b9c2a35ob1e44d70f131890c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b637ec0b0908220602v3b9c2a35ob1e44d70f131890c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 22, 2009 at 03:02:26PM +0200, Fabio Comolli wrote:
> Hi Bob.
> 
> I'm not a git user. How can I user wireless-testing without git? Is
> there a patch or seomething?

No, I'm unaware of a way to get it without git.  Well, okay, try
compat-wireless, but be sure to use the 'bleeding edge' compat-wireless,
and post the contents of its 'git-describe' file with the warnings so
I can be sure we're on the same page.

http://wireless.kernel.org/en/users/Download

-- 
Bob Copeland %% www.bobcopeland.com

