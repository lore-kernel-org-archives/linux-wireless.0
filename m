Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49005 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2A3SqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 13:46:25 -0500
Date: Mon, 30 Jan 2012 13:39:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@canonical.com>
Subject: Re: rtl8187 behavior change/breakage with
 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
Message-ID: <20120130183924.GA2493@tuxdriver.com> (sfid-20120130_194629_339949_7D745BFC)
References: <4F25BD09.3060607@lwfinger.net>
 <1327924292.6683.YahooMailClassic@web29506.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1327924292.6683.YahooMailClassic@web29506.mail.ird.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 11:51:32AM +0000, Hin-Tak Leung wrote:
> --- On Sun, 29/1/12, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > > This may be a fedora-specific problem - I noticed that
> > just after booting into the new fedora kernel
> > (3.2.2-1.fc16.x86_64), I am getting a strange message from
> > the kernel:
> > >
> > > rtl8187: Invalid hwaddr! Using randomly generated MAC
> > address
> 
> 
> > I just checked, and rtl8187 works fine with my RTL8187L
> > using 3.3-rc1 from 
> > wireless-testing. I don't know where the problem occurs.
> 
> Thanks for looking. It is mostly likely a fedora-specific problem then. Unless John has any idea, I'll eventually unpacking the fedora kernel source if the problem persists for another kernel.
> 
> Cheers,
> Hin-Tak
> 
> P.S. Herton's e-mail seems to have changed.

When I integrated compat-wireless into the Fedora kernels, I
left it using the in-kernel eeprom_93cx6 driver.  Apparently some
incompatiblity has krept-in, and several wireless drives stopped
working.  I have changed the fedora kernels to use the version of
eeprom_93cx6 now, so the next build should work alright.

Sorry!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
