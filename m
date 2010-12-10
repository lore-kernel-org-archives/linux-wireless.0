Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0LJSWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 13:22:38 -0500
Date: Fri, 10 Dec 2010 19:22:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] .36 ath9k patches for .35-longterm
Message-ID: <20101210182233.GD3965@basil.fritz.box>
References: <20101210093258.GA4703@basil.fritz.box>
 <AANLkTimnfAbDnKQbxLrwOHTD-CFXn1TJh91PuC=2QuUM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTimnfAbDnKQbxLrwOHTD-CFXn1TJh91PuC=2QuUM@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 07:56:37AM -0800, Luis R. Rodriguez wrote:
> On Fri, Dec 10, 2010 at 1:32 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > I sent this to the athk9 maintainers earlier, but it looks like
> > Atheros' mailserver doesn't like my mailserver and I got a bounce.
> > Resending to the lists.
> 
> Heh, odd.

It complained that my IP was non trusted.

As far as I can see the problem is that your barracuda email
appliance looks for any IP addresses in email headers --
not just the IP address of the delivering mail server -- 
and since I send from a dynamic address as first
step it fails.

> > ath9k-fix-timeout-on-stopping-rx-dma.patch
> >
> > Some of them apply to .35, but a lot of others do not and I found
> > it difficult to decide which ones are suitable for 2.6.36
> 
> You mean for 2.6.35?

yes, sorry for the typo

> Eek, um OK, we'll give this a some good review and get back to you.

Thanks.

> http://git.kernel.org/?p=linux/kernel/git/mcgrof/compat-wireless-2.6.git;a=tree;h=refs/heads/linux-2.6.36.y;hb=refs/heads/linux-2.6.36.y
> 
> > Right now I didn't merge any ath9x patches until this is resolved.
> 
> This will take a bit of time, as some of these patches may require
> manual backport and as you noted some dependencies. Given that this is

The question is if they are critical for .35. Are they?
If not can you just send the ones which are critical?

> for long term we will do some work to get this to you. Its too bad we
> can't get AR9003 support in there, that's a huge set of patches
> though.

Non trivial new hardware support is out of scope.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
