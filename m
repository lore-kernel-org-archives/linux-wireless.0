Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21016 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXKVPml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 10:42:41 -0500
Received: from lin01.mn-solutions.de (pD95F8740.dip0.t-ipconnect.de [217.95.135.64])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id DD5725E4007
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:42:39 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 35D841E00FD
	for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 16:39:45 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: mac80211 regression: doesn't associate automatically
Date: Thu, 22 Nov 2007 16:43:08 +0100
References: <200711220912.10452.hs4233@mail.mn-solutions.de> <200711221605.55506.hs4233@mail.mn-solutions.de> <1195744414.4149.14.camel@johannes.berg>
In-Reply-To: <1195744414.4149.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200711221643.08290.hs4233@mail.mn-solutions.de> (sfid-20071122_154243_462130_9C146902)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Bottom line is, I don't care.

So much I figured out by myself.


Maybe you can show me a non-mac80211 driver that behaves in the 
same way as mac80211?  In other words, a driver where you can do

ifconfig eth1 up
iwconfig eth1 essid SOMESSID
iwconfig eth1 key s:11111

and where, as in mac80211, you don't get an association (assuming 
that the AP is set up accordingly). If you can show me 5 
drivers, than I'm willing to assume that there is no regression.


So far I haven't seen one non-mac80211 driver that did not 
associate with this sequence.
