Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1925 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZHMDAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 23:00:16 -0400
Date: Wed, 12 Aug 2009 22:59:09 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath5k-devel@lists.ath5k.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 0/3] ath: advance ath.ko with one more
	helper
Message-ID: <20090813025909.GB28871@hash.localnet>
References: <1250096221-11000-1-git-send-email-lrodriguez@atheros.com> <b6c5339f0908121021x3bc9fe26vb17532de6c464b7f@mail.gmail.com> <43e72e890908121027x5211c7cja3185861bc9c02f1@mail.gmail.com> <40f31dec0908121913y1dc39032p26556135f22c3f48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0908121913y1dc39032p26556135f22c3f48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 05:13:50AM +0300, Nick Kossifidis wrote:
> You mean have a common reg.h for both ath5k and ath9k ?

I meant the existing regulatory, not register, headers -- but if
there is stuff to be shared in reg[ister].h we can do that too.

> code is much cleaner than ath9k and it's a better place to start, i've
> seen most hw
> code on ath9k and i'm ready to move on if it's O.K. with you.

I guess we should coordinate a bit.  I don't have much in the way
of unsent patches but perhaps we should pick a specific time to
start moving stuff around so we don't all have a pile of rejects.
Maybe after 2.6.32 merge window?

(This particular patch series, though, is fine enough now I think.)

-- 
Bob Copeland %% www.bobcopeland.com

