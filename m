Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:27727 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbYCaJTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 05:19:44 -0400
Received: from lin01.mn-solutions.de (pD95FA2DB.dip0.t-ipconnect.de [217.95.162.219])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 31AA45E401F
	for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 11:19:40 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 953721E0096
	for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 11:16:48 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Add PIO support for PCMCIA devices
Date: Mon, 31 Mar 2008 11:16:47 +0200
References: <200803292101.16696.mb@bu3sch.de>
In-Reply-To: <200803292101.16696.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200803311116.47928.hs4233@mail.mn-solutions.de> (sfid-20080331_101947_283793_A475F480)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> PIO is needed for 16bit PCMCIA devices, as we really don't
> want to poke with the braindead DMA mechanisms on PCMCIA
> sockets. Additionally, not all PCMCIA sockets do actually
> support DMA in 16bit mode (mine doesn't).

Does this mean there are b43 based compact flash cards available?
