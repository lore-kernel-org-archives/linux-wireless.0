Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40940 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab0JLSaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 14:30:07 -0400
Date: Tue, 12 Oct 2010 14:18:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-wireless@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ben Greear <greearb@candelatech.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath5k: fix build break from "ath5k: Print out opmode in
 debugfs"
Message-ID: <20101012181804.GC2403@tuxdriver.com>
References: <20101012163519.a88f2040.sfr@canb.auug.org.au>
 <1286895206-3030-1-git-send-email-linville@tuxdriver.com>
 <AANLkTi=Rj+hmYthVcwYksSxUqFF+117FxVvdnuDCLxVY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=Rj+hmYthVcwYksSxUqFF+117FxVvdnuDCLxVY@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 11:13:31AM -0700, Linus Torvalds wrote:
> On Tue, Oct 12, 2010 at 7:53 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> >
> > Please don't make me commit such an ugly patch...
> 
>  Why don't you just create a dummy inline ath_opmode_to_string() that
> returns NULL in the non-debug case? The compiler will make the
> conditionals all go away, and it will end up being "UNKNOWN" which is
> just what you want. No?

Shhh!  Your messing-up my manipulative mind games! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
