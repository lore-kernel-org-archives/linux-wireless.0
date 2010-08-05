Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hyde.gogi.tv ([87.106.167.24]:51684 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677Ab0HEQkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 12:40:32 -0400
From: Daniel Haid <d.haid@gogi.tv>
To: ABM Musa <amusa2@uic.edu>
Subject: Re: Capturing packets with bad FCS in monitor mode
Date: Thu, 5 Aug 2010 18:40:18 +0200
Cc: linux-wireless@vger.kernel.org
References: <201008051614.11546.d.haid@gogi.tv> <201008051819.55252.d.haid@gogi.tv> <4C5AE723.5070708@uic.edu>
In-Reply-To: <4C5AE723.5070708@uic.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008051840.18914.d.haid@gogi.tv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I can get packets with crc error using this method and I get lot of
> corrupted packets. I am using ath9k with openwrt for router station
> pro+ubiquity sr-71A card and tplink 1043nd.

I am using an ubiquity sr-71X card, and still not one corrupted packet.

I think I need to artificially create and transmit a corrupted packet. How
can I do that?
