Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21232 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXKVPo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:44:58 -0500
Received: from lin01.mn-solutions.de (pD95F8740.dip0.t-ipconnect.de [217.95.135.64])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id EC62E5E4005
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:44:56 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id D4CD41E00FD
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:42:02 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 16:45:25 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <1195736752.6323.97.camel@johannes.berg> <200711221514.37906.hs4233@mail.mn-solutions.de>
In-Reply-To: <200711221514.37906.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221645.26024.hs4233@mail.mn-solutions.de> (sfid-20071122_154506_192059_8967D8D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> * orinoco_cs works that way
> * ipw2200 (in kernel) also
> * wlags49_h1_cs (an out-of-kernel driver) also
> * wlags49_h2_cs also
> * bcm43xx (sucky in many ways) worked too
> * libertas_cs/usb8xxx (in kernel) also
> * madwifi also

I found a 7th driver that worked in this way: p54pci.ko

As it stands, I found not a single non-mac80211 WLAN driver where 
the sequence "ifconfig XXX up", "iwconfig XXX essid 
YYYY", "iwconfig XXX key ZZZZ" did get me an association.
