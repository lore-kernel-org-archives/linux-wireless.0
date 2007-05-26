Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762285AbXEZP5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2007 11:57:38 -0400
From: Uwe Bugla <uwe.bugla@gmx.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: BUG in 2.6.22-rc2-mm1: NIC module b44.c broken (Broadcom 4400)
Date: Sat, 26 May 2007 17:52:14 +0200
References: <20070524195616.234280@gmx.net> <200705261240.55153.uwe.bugla@gmx.de> <200705261736.57362.mb@bu3sch.de>
In-Reply-To: <200705261736.57362.mb@bu3sch.de>
Cc: Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200705261752.14929.uwe.bugla@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 26. Mai 2007 17:36 schrieben Sie:
> On Saturday 26 May 2007 12:40:54 Uwe Bugla wrote:
> > Yes! This sort of mistakes is completely impossible, as I use to work
> > with aliases rather than IP adresses. The machine I tried to ping (i. e.
> > my router) is called Jerry (as a reminiscence to Mr. "Captan Trips" from
> > Grateful Dead), and thus "ping jerry" returned the following:
> >
> > "destination host unreachable"
> >
> > Above that, I state for the second time now that I reverted your patches
> > in 2.6.22-rc2-mm1 with the effect that everything worked perfectly! Maxi
> > said something at least similar. So how many proofs do you need, Mister
> > Buesch, to finally pick up patchworking now??
>
> How about you stopping with your fucking aggressive wording??

If you stop repeating that you are not responsible for that buggy stuff then I 
will be friendlier. That's all.
So calm down and provide me some parametres to debug.
I will be cooperative and we're gonna fix it for sure, OK?

>
> > > Try it again, please.
> >
> > NO!
> >
> > > And please try with current wireless-dev tree.
> >
> > A. I do not know where to download that wireless-dev tree.
> > B. I do not know how to implement it into mm or mainline
> > C. I have given enough sophisticated proof that your stuff in mm-tree is
> > highly incomplete / buggy.
>
> Ok,
>
> D. As you are not going to help me debugging, I am not going to fix.

First of all, I need debugging parametres for both modules (b44 and ssb).
Second, I need to know which log you need after using those debug parametres.

This is the only chance to move forward, isn't it?

>
> > > And I simply do not get it why you suddenly get a good IRQ number, like
> > > everybody else does, without fixing The Bug (tm).
> >
> > That consequence I already explained:
> > But it's a pleasure for me to repeat it once more:
> >
> > When you are saying Y to "EISA, VLB, PCI and on board controllers"
> >
> > you simply do get not only completely different interrupts for the b4401
> > device, but you get also completely different module dependencies.
>
> That is EXPECTED and I already explained that.
> It is a feature. Not a bug.

Yes. But the features / extensions / different cases of b44 usage need to be 
explained in some small Kconfig text, making it easy for users to put the 
right selection for their specific NIC controller. But exactly this Kconfig 
leaves you in the dark. That's it what I critizise, nothing else. Just try to 
see through my eyes: Who would be happy with guessing around? Noone.

Cheers

Uwe
