Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55748 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728AbZACCuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 21:50:55 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 2C0B21C067216
	for <linux-wireless@vger.kernel.org>; Sat,  3 Jan 2009 03:50:52 +0100 (CET)
Date: Sat, 3 Jan 2009 03:50:52 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: linux-wireless@vger.kernel.org
Subject: b43 depends on lots of modules
Message-ID: <alpine.LSU.2.00.0901030349030.3914@fbirervta.pbzchgretzou.qr> (sfid-20090103_035059_724251_DBBBA065)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I noticed that the b43 module has a lot of dependencies, among:

depends:        pcmcia,mac80211,ssb,input-polldev,pcmcia_core,led-class,rfkill,rng-core,firmware_class

Why does it depend on PCMCIA when I hear that b43 devices are also 
available in PCI variants? Similarly, is SSB needed on x86en which
usually don't have such?
