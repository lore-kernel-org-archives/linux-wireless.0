Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1446 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbXHBG0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 02:26:54 -0400
Received: from lin01.mn-solutions.de (pD95F872D.dip0.t-ipconnect.de [217.95.135.45])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 625E65E5AD3
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 08:26:53 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 89C0C1E002B
	for <linux-wireless@vger.kernel.org>; Thu,  2 Aug 2007 08:26:48 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: libertas: blows chunks on failed firmware load
Date: Thu, 2 Aug 2007 08:26:47 +0200
References: <46AF913F.9010006@warmcat.com> <200708011131.22390.hs4233@mail.mn-solutions.de> <46B109C8.9090704@warmcat.com>
In-Reply-To: <46B109C8.9090704@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708020826.47399.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02 August 2007 00:31, Andy Green wrote:
> Well it seems the libertas_cs driver supports PCMCIA only? 

Right, like libertas_cs is --- like e.g. orinoco_cs --- just for 
for PCMCIA based designs, like CF CARD. If you have a PCI based 
device, you'll need to write your own libertas_pci driver

