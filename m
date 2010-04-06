Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22739 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab0DFJ52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 05:57:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 02:57:28 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19387.2645.292051.877612@gargle.gargle.HOWL>
Date: Tue, 6 Apr 2010 15:47:57 +0530
To: Pavel Roskin <proski@gnu.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath: Add a bus type field
In-Reply-To: <1270138075.4608.31.camel@mj>
References: <19380.10220.955466.246781@gargle.gargle.HOWL>
	<1270138075.4608.31.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Thu, 2010-04-01 at 10:28 +0530, Sujith wrote:
> > This can be used to store the bus types ( AHB/PCI/USB ).
>  
> > +enum ath_bus_type {
> > +	ATH_PCI,
> > +	ATH_AHB,
> > +	ATH_USB,
> > +};
> 
> I like the idea, but let's have ATH_BUS_PCI, ATH_BUS_AHB and
> ATH_BUS_USB.  This way, one would be able to grep for "ATH_BUS_" to find
> all occurrences of those symbols.
> 
> There are already symbols starting with "ATH_PCI", such as
> ATH_PCIE_CAP_LINK_CTRL.

Sorry, I just noticed this mail.
A number of pending patches are on top of this one.
Maybe this can be done later ?

Sujith
