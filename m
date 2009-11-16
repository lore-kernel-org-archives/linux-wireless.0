Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39645 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZKPWaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 17:30:24 -0500
Date: Mon, 16 Nov 2009 17:22:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8187se: Rename staging driver to avoid
	name conflict with mainline driver
Message-ID: <20091116222239.GA1308@tuxdriver.com>
References: <4b016848.3j3kclbqZ4ylyZGU%Larry.Finger@lwfinger.net> <69e28c910911161202w5255bff5ydb7fc665b3320bda@mail.gmail.com> <4B01CD9D.7040601@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4B01CD9D.7040601@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 16, 2009 at 04:09:33PM -0600, Larry Finger wrote:
> On 11/16/2009 02:02 PM, Gábor Stefanik wrote:
> >>
> >> -obj-$(CONFIG_RTL8187SE)        += rtl8187se.o
> >> +obj-$(CONFIG_RTL8187SE_STAGE)  += rtl8187se_stage.o
> > 
> > Please make this r8187se.o, to be consistent with the other
> > r8180-sa2400 derivative drivers.
> 
> I cannot do that. From what I see, the kernel make system creates the .ko file
> from the name specified here. When I make that rtl8187se.o, then I get
> rtl8187se.ko, which is what I want to avoid.

Gábor is suggesting r{no t}{no l}8187se... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
