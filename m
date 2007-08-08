Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12769 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbXHHGsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 02:48:12 -0400
Received: from lin01.mn-solutions.de (pD95FA8BF.dip0.t-ipconnect.de [217.95.168.191])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id A2FCA8B02B1
	for <linux-wireless@vger.kernel.org>; Wed,  8 Aug 2007 08:48:11 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 0BF6B1E002B
	for <linux-wireless@vger.kernel.org>; Wed,  8 Aug 2007 08:48:06 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Marvell pci wifi chips
Date: Wed, 8 Aug 2007 08:48:12 +0200
References: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
In-Reply-To: <a728f9f90708070921x13c1a9fem8f7bbf3fe77756d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708080848.12531.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- marvell GPL driver
> (http://johannes.sipsolutions.net/files/marvell.tar.bz2)

I looked at this driver. Yes, it seems to be for a PCI Marvell 
WLAN chip.

But looking at the registers (e.g. bit definitions), this driver 
seems to have a very (!) different architecture to the 
CF/SDIO/USB based 83xx chips the libertas driver supports.


So feel free to grab this driver, push it in shape and submit it 
to the Linux kernel. It's GPL, after all :-)
