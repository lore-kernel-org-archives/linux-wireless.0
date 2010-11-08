Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40366 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab0KHVAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 16:00:20 -0500
Date: Mon, 8 Nov 2010 15:57:05 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: bluetooth-2.6 2010-10-30
Message-ID: <20101108205704.GB2310@tuxdriver.com>
References: <20101030031503.GB24188@vigoh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101030031503.GB24188@vigoh>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 30, 2010 at 04:15:03AM +0100, Gustavo F. Padovan wrote:
> Hi John,
> 
> The following batch contains some bugfixes for 2.6.37. A fix for unaligned
> access in L2CAP, a Kconfig error, and two fixes related to security of
> the Bluetooth links. There is also a one line patch from Matthew Garret,
> that enables USB autosuspend for btusb module, which shall be completely
> safe. Please pull, thanks.
> 
> 
> The following changes since commit c1758012971e0410790b2bc96a77e26d7b286593:
> 
>   igb: Fix unused variable warning. (2010-10-27 19:43:55 -0700)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git master

Gustavo,

I'm happy to take your patches.  But if you want me to pull from you
then I need your bluetooth-2.6 tree to be based upon wireless-2.6
(and bluetooth-next-2.6 to be based upon wireless-next-2.6), with only
the bluetooth patches on top.

If that is a problem, then you can send me a stack of patches for
me to apply manually instead.  Otherwise I will get patches I don't
necessarily want pulled into wireless-2.6 and could even accidentally
push patches to davem that he might not want either.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
