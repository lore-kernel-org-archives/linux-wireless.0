Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2268 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbXHGSGG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 14:06:06 -0400
Date: Tue, 7 Aug 2007 13:34:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Marvell pci wifi chips
Message-ID: <20070807173431.GC3330@tuxdriver.com>
References: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 07, 2007 at 12:21:02PM -0400, Alex Deucher wrote:
> Is anyone working on a driver for the marvell pci libertas chips
> (8335, 8300, 8310, etc.) or know of someone who is?  I've got several
> of these cards not doing anything at the moment if someone is
> interested in one.  It seems there are several drivers floating
> around:
> 
> - mrv8k driver (http://www.saillard.org/linux/mrv8k/)
> - openbsd malo driver (http://www.openbsd.org/cgi-bin/man.cgi?query=malo)
> - marvell GPL driver (http://johannes.sipsolutions.net/files/marvell.tar.bz2)
> 
> Reading through the linux-wireless archive, several people seemed to
> indicate there was work going on, but I have not been able to find any
> information on that other than Holger's CF libertas integration.  I
> and others have asked before, but there seems to be some confusion as
> to the whole libertas line and their relative compatibility.  Just
> curious.

I think I saw discussion lately to the effect that the PCI devices are
not currently supported, and that they likely could be supported by
simply implementing a PCI front-end to the core of the libertas code.
I think Holger is the person most likely to know for sure.

I've got cards like that too -- would love for you to get them
working... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
