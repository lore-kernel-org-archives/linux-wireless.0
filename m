Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44467 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbZCWUAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 16:00:45 -0400
Date: Mon, 23 Mar 2009 15:53:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
Message-ID: <20090323195328.GH3285@tuxdriver.com> (sfid-20090323_210048_130162_25B33ED7)
References: <49A7236E.2020807@gmail.com> <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com> <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet> <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet> <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet> <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com> <20090323030419.GA5803@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323030419.GA5803@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 11:04:19PM -0400, Bob Copeland wrote:
> On Tue, Mar 03, 2009 at 06:31:05AM +0200, Nick Kossifidis wrote:
> > and i don't believe i've ever seen them, so we can warn on them too
> > and print something like "Reserved rate code: %x", also it would be
> > nice to warn on XR rates (1,2,3,6,7) in case we want to debug this in
> > the future.
> 
> Nick, are you ok with taking this patch as-is and adding the other stuff
> in later?  It does fix a warning in mac80211 for unknown rates and 
> instead warns with the actual hw rate code we get.
> 
> Here's a repost (rebased, if it matters):
> 
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 2 Mar 2009 21:55:18 -0500
> Subject: [PATCH] ath5k: warn and correct rate for unknown hw rate indexes

I've got this one now.  Just FYI, I'll be prone to losing any
patches posted in the middle of a thread if the Subject isn't changed
appropriately.  FWIW, 'git send-email' can accept an "--in-reply-to"
argument.  So when replying in a thread you can say "Oh yeah, I see
the problem...patch to follow" and then send the patch in a separate
email with it's own subject so that I will see it even if I'm buried
(at least most of the time).

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
