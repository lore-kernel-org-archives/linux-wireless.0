Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6810 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbXFKGgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2007 02:36:38 -0400
Received: from lin01.mn-solutions.de (pD95F9680.dip0.t-ipconnect.de [217.95.150.128])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 3A1025E45C3
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 08:36:36 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 3721B1E002B
	for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2007 08:36:30 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Marvell CB35 cardbus cards
Date: Mon, 11 Jun 2007 08:36:29 +0200
References: <1181061336.8274.36.camel@johannes.berg> <20070606150438.GB4572@tuxdriver.com>
In-Reply-To: <20070606150438.GB4572@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706110836.29921.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have a device, and probably a copy of the code you have.  A
> driver is in progress -- just (hopefully) resolved some
> firmware loading issues.

My driver downloads the firmware fine, and I just started to 
implement the ISR. The patches are not yet in "fine" format, 
e.g. scripts/checkpatch.pl (from 2.6.22-rc4) still complains 
about minor issues.

Patches are against libertas-2.6

http://projects.linuxtogo.org/plugins/scmsvn/viewcvs.php/trunk/libertas-patches/?root=marvell8385
