Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57213 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAQPPS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 10:15:18 -0500
Date: Fri, 17 Jan 2014 10:01:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140117150127.GA15145@tuxdriver.com> (sfid-20140117_161527_413364_CDDB5269)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
 <20140117014514.GA604@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140117014514.GA604@earth.universe>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 02:45:15AM +0100, Sebastian Reichel wrote:
> On Mon, Jan 06, 2014 at 11:57:09PM +0100, Sebastian Reichel wrote:
> > Hi John,
> > 
> > > The following patchset adds device tree support to
> > > the spi variant of the wl1251 driver.
> > >
> > > Luciano Coelho (1):
> > >   wl1251: split wl251 platform data to a separate structure
> > > 
> > > Sebastian Reichel (4):
> > >   wl1251: move power GPIO handling into the driver
> > >   wl1251: spi: add vio regulator support
> > >   wl1251: spi: add device tree support
> > >   Documentation: dt: wireless: Add wl1251
> > 
> > What's the status of this patchset? Tony prepared an immutable
> > branch for patches 1+2 [0]. I think the other patches are also ok
> > (at least there were no more complains from the DT binding
> > maintainers). It would be nice to have wl1251 DT support in 3.14.
> > 
> > [0] http://www.spinics.net/lists/linux-omap/msg101165.html
> > 
> > -- Sebastian
> 
> ping? I can't see it on wireless-next.

I can't pull it because the branch is based on a later source than
that of wireless-next.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
