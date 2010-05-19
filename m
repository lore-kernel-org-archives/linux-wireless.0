Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:52621 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab0ESKVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 06:21:03 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Dan Williams' <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Kiran Divekar <dkiran@marvell.com>
Date: Wed, 19 May 2010 03:21:00 -0700
Subject: RE: [PATCH v3] libertas: Added callback functions to support SDIO
 suspend/resume.
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF595056D1B6FD8@SC-VEXCH1.marvell.com>
In-Reply-To: <1274157122.14012.14.camel@localhost.localdomain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> 
> Looks OK to me...
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

Thanks. I will resend the patch with a minor typo fix.
> 
> > ---
> >  drivers/net/wireless/libertas/cmd.c     |   37 ++++++++++++--
> >  drivers/net/wireless/libertas/cmdresp.c |   30 ++---------
> >  drivers/net/wireless/libertas/decl.h    |    2 +-
> >  drivers/net/wireless/libertas/dev.h     |    6 ++

Thanks,
Amit.
