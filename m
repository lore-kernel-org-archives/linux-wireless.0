Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59118 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab1AZQfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 11:35:09 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Pi8Kn-0001Qf-3O
	for linux-wireless@vger.kernel.org; Wed, 26 Jan 2011 17:35:05 +0100
Received: from san_juan-143-68.umh.es ([san_juan-143-68.umh.es])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 17:35:05 +0100
Received: from baldo.ath9k by san_juan-143-68.umh.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 17:35:05 +0100
To: linux-wireless@vger.kernel.org
From: Baldomero Coll <baldo.ath9k@gmail.com>
Subject: Re: [RFC] mac80211: support for IEEE80211N in IBSS
Date: Wed, 26 Jan 2011 16:31:54 +0000 (UTC)
Message-ID: <loom.20110126T172928-834@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've already test this patch, but I'm not pretty sure if I'm doing something 
wrong.
I've applied the patch on the compact-wireless-2-.6.37-4.tar.bz2. 

When I create the ibss network and set the channel 1 HT20 It seems that all is 
going right.

How could i know if the wireless interface is really configured in HT mode?
I have transmitted a large file between two laptops and It's not possible to 
appreciate performance differences with the simple channel 1.

Baldo




