Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm13.bullet.mail.ird.yahoo.com ([77.238.189.66]:27439 "HELO
	nm13.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753793Ab2AaKpM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 05:45:12 -0500
Message-ID: <1328006709.47544.YahooMailClassic@web29504.mail.ird.yahoo.com> (sfid-20120131_114521_315777_6C216947)
Date: Tue, 31 Jan 2012 10:45:09 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: rtl8187 behavior change/breakage with 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <20120130183924.GA2493@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 30/1/12, John W. Linville <linville@tuxdriver.com> wrote:

> On Mon, Jan 30, 2012 at 11:51:32AM
> +0000, Hin-Tak Leung wrote:
> > --- On Sun, 29/1/12, Larry Finger <Larry.Finger@lwfinger.net>
> wrote:
> > 
> > > > This may be a fedora-specific problem - I
> noticed that
> > > just after booting into the new fedora kernel
> > > (3.2.2-1.fc16.x86_64), I am getting a strange
> message from
> > > the kernel:
> > > >
> > > > rtl8187: Invalid hwaddr! Using randomly
> generated MAC
> > > address
> > 
> > 
> > > I just checked, and rtl8187 works fine with my
> RTL8187L
> > > using 3.3-rc1 from 
> > > wireless-testing. I don't know where the problem
> occurs.
> > 
> > Thanks for looking. It is mostly likely a
> fedora-specific problem then. Unless John has any idea, I'll
> eventually unpacking the fedora kernel source if the problem
> persists for another kernel.
> > 
> > Cheers,
> > Hin-Tak
> > 
> > P.S. Herton's e-mail seems to have changed.
> 
> When I integrated compat-wireless into the Fedora kernels,
> I
> left it using the in-kernel eeprom_93cx6 driver. 
> Apparently some
> incompatiblity has krept-in, and several wireless drives
> stopped
> working.  I have changed the fedora kernels to use the
> version of
> eeprom_93cx6 now, so the next build should work alright.

Thanks for checking! I'll await the next fedora update. No prob - these things happen from time to time: living life on the bleeding-edge!

Hin-Tak

