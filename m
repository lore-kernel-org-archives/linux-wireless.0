Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:42416 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab1HKPip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 11:38:45 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 11 Aug 2011 17:38:30 +0200
Subject: RE: [RFC] NFC: NCI protocol proposal
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131D0F1D9@dnce02.ent.ti.com> (sfid-20110811_173848_576483_51E64811)
References: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com>
	 <CAK3JMAa=1kuP7CRRMBLxZtMromYbDMz18W6ZT=1KoSCD=tfFkQ@mail.gmail.com>
	 (sfid-20110809_194411_068851_56DC16DA)
 <1312912950.3966.5.camel@jlt3.sipsolutions.net>
In-Reply-To: <1312912950.3966.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, Johannes,

> 
> On Tue, 2011-08-09 at 14:43 -0300, Lauro Ramos Venancio wrote:
> 
> > > We need to add the following 2 control operations (via generic
> > > netlink):
> > >        - Dev_up, which turn on the NFC controller (this operation may
> > > take a   few seconds, as it can download new FW to the NFC controller)
> > >        - Dev_down, which turn off the NFC controller
> > > The dev_up/down approach was also used with HCI protocol in the BlueZ
> > > project.
> >
> > I am not completely convinced that we need the dev up/down. Why is it
> > not possible to load the FW in the probe?
> 
> The usual problem, if the driver is built-in then the probe will run
> before userspace is available to load firmware.
> 
> johannes

Thanks for your comments.

BR,
Ilan
