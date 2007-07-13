Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13421 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbXGMHJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2007 03:09:48 -0400
Received: from lin01.mn-solutions.de (pD95F854E.dip0.t-ipconnect.de [217.95.133.78])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 864C88B0373
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2007 09:09:48 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id BA5B81E002B
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2007 09:09:42 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [patch 1/2] Merge the Sonics Silicon Backplane subsystem
Date: Fri, 13 Jul 2007 09:09:54 +0200
References: <20070712085432.528319000@bu3sch.de> <20070712085744.604965000@bu3sch.de> <20070713061100.GA28974@hall.aurel32.net>
In-Reply-To: <20070713061100.GA28974@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707130909.54856.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +#define	SSB_EXTIF_BASE		0x1f000000	/* External Interface
> > +#define	SSB_EUART		(SB_EXTIF_BASE + 0x00800000)
> > +#define	SSB_LED			(SB_EXTIF_BASE + 0x00900000)
>
> I have just noticed a typo here. That should be SSB_EXTIF_BASE
> instead of SB_EXTIF_BASE.

Or remove those two defines completely, obviously they are unused.
Otherwise Michael would have get an compiler error.

