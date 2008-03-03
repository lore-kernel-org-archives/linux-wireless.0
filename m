Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbYCCPb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 10:31:27 -0500
Subject: Re: Netgear WG311v3 - Marvell 88w8355 "Libertas"
From: Dan Williams <dcbw@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <646765f40803022006h39ec0c43uf9af99924dedc29@mail.gmail.com>
References: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
	 <1204472016.13121.27.camel@localhost.localdomain>
	 <646765f40803021401i65e31e16v5efd0784bffcc177@mail.gmail.com>
	 <1204505713.3070.0.camel@localhost.localdomain>
	 <646765f40803022006h39ec0c43uf9af99924dedc29@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:28:37 -0500
Message-Id: <1204558117.3155.1.camel@localhost.localdomain> (sfid-20080303_153142_354547_955D337F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-03 at 15:06 +1100, Julian Calaby wrote:
> On Mon, Mar 3, 2008 at 11:55 AM, Dan Williams <dcbw@redhat.com> wrote:
> >
> > On Mon, 2008-03-03 at 09:01 +1100, Julian Calaby wrote:
> >  > Well, that explains why the "Libertas" parts supported by the current
> >  > kernel require firmware and why the ndiswrapper driver I'm using
> >  > doesn't.
> >
> >  The 8335 still requires firmware.  Lots of the windows drivers embed the
> >  firmware into the .sys or .dll files, whereas on Linux embedding
> >  firmware into the driver is quite frowned upon.
> 
> Yeah, I discovered that the mrv8k driver still requires firmware,
> despite there being no actual file in the windows driver that I can
> point to as being the firmware image.

It's likely embedded into the sys file, try:

http://www.saillard.org/linux/mrv8k/files/mrv8k_extract_fw.c

to extract the firmware from a supported driver file.  At least one
versoin of WG311v3 driver seems to be supported there ("NETGEAR
WG311v3", "3.1.1.7") for extracting the firmware from.

Dan


