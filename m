Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:16857 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbXJIMiD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 08:38:03 -0400
Received: from lin01.mn-solutions.de (pD95FA8E3.dip0.t-ipconnect.de [217.95.168.227])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id C267D5E59FE
	for <linux-wireless@vger.kernel.org>; Tue,  9 Oct 2007 14:37:59 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 0285B1E002B
	for <linux-wireless@vger.kernel.org>; Tue,  9 Oct 2007 14:35:04 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: remove one superfluous include
Date: Tue, 9 Oct 2007 14:38:13 +0200
References: <200710091430.11043.hs4233@mail.mn-solutions.de>
In-Reply-To: <200710091430.11043.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710091438.13738.hs4233@mail.mn-solutions.de> (sfid-20071009_133807_893575_F559BDC1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This makes scripts/checkincludes.pl happy.

Hehe, others have problems, too:

$ scripts/checkincludes.pl drivers/net/wireless/*.h
drivers/net/wireless/ipw2200.h: linux/dma-mapping.h is included 
more than once.



(in wireless-2.6 everything)
