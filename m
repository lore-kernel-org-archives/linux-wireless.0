Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:4207 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbXHHE3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 00:29:19 -0400
Received: by rv-out-0910.google.com with SMTP id k20so43074rvb
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2007 21:29:19 -0700 (PDT)
Message-ID: <a728f9f90708072129m2c5dd9f8j70e5bba44e504ff0@mail.gmail.com>
Date: Wed, 8 Aug 2007 00:29:19 -0400
From: "Alex Deucher" <alexdeucher@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Marvell pci wifi chips
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070807173431.GC3330@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
	 <20070807173431.GC3330@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/7/07, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Aug 07, 2007 at 12:21:02PM -0400, Alex Deucher wrote:
> > Is anyone working on a driver for the marvell pci libertas chips
> > (8335, 8300, 8310, etc.) or know of someone who is?  I've got several
> > of these cards not doing anything at the moment if someone is
> > interested in one.  It seems there are several drivers floating
> > around:
> >
> > - mrv8k driver (http://www.saillard.org/linux/mrv8k/)
> > - openbsd malo driver (http://www.openbsd.org/cgi-bin/man.cgi?query=malo)
> > - marvell GPL driver (http://johannes.sipsolutions.net/files/marvell.tar.bz2)
> >
> > Reading through the linux-wireless archive, several people seemed to
> > indicate there was work going on, but I have not been able to find any
> > information on that other than Holger's CF libertas integration.  I
> > and others have asked before, but there seems to be some confusion as
> > to the whole libertas line and their relative compatibility.  Just
> > curious.
>
> I think I saw discussion lately to the effect that the PCI devices are
> not currently supported, and that they likely could be supported by
> simply implementing a PCI front-end to the core of the libertas code.
> I think Holger is the person most likely to know for sure.
>
> I've got cards like that too -- would love for you to get them
> working... :-)

Has anyone tested the marvell driver
(http://johannes.sipsolutions.net/files/marvell.tar.bz2)?  Does it
work?

Alex
