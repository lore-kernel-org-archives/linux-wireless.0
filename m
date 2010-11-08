Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41944 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab0KHVPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 16:15:19 -0500
Date: Mon, 8 Nov 2010 19:15:31 -0200
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-10-30
Message-ID: <20101108211531.GC19199@vigoh>
References: <20101030031503.GB24188@vigoh>
 <20101108205704.GB2310@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101108205704.GB2310@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

* John W. Linville <linville@tuxdriver.com> [2010-11-08 15:57:05 -0500]:

> On Sat, Oct 30, 2010 at 04:15:03AM +0100, Gustavo F. Padovan wrote:
> > Hi John,
> > 
> > The following batch contains some bugfixes for 2.6.37. A fix for unaligned
> > access in L2CAP, a Kconfig error, and two fixes related to security of
> > the Bluetooth links. There is also a one line patch from Matthew Garret,
> > that enables USB autosuspend for btusb module, which shall be completely
> > safe. Please pull, thanks.
> > 
> > 
> > The following changes since commit c1758012971e0410790b2bc96a77e26d7b286593:
> > 
> >   igb: Fix unused variable warning. (2010-10-27 19:43:55 -0700)
> > 
> > are available in the git repository at:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master
> 
> Gustavo,
> 
> I'm happy to take your patches.  But if you want me to pull from you
> then I need your bluetooth-2.6 tree to be based upon wireless-2.6
> (and bluetooth-next-2.6 to be based upon wireless-next-2.6), with only
> the bluetooth patches on top.
> 
> If that is a problem, then you can send me a stack of patches for
> me to apply manually instead.  Otherwise I will get patches I don't
> necessarily want pulled into wireless-2.6 and could even accidentally
> push patches to davem that he might not want either.

No problem to me, sure I can rebase on top of your trees. I'll re-base my
trees and resend the pull request to you.

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
