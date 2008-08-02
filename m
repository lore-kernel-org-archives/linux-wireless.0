Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from john.hrz.tu-chemnitz.de ([134.109.132.2]:33528 "EHLO
	john.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbYHBUba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 16:31:30 -0400
From: Stefan Bauer <stefan.bauer@informatik.tu-chemnitz.de>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt61pci: 2.6.26 Regression: TX/RX LED not flickering anymore
Date: Sat, 2 Aug 2008 22:29:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <200808012238.49755.stefan.bauer@cs.tu-chemnitz.de>
In-Reply-To: <200808012238.49755.stefan.bauer@cs.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808022229.38525.stefan.bauer@informatik.tu-chemnitz.de> (sfid-20080802_223143_656431_F1DAD925)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 01 August 2008 22:38, Stefan Bauer wrote:
> The card has 2 LEDs, link and TX/RX. The latter used to flicker nicely on
> data transfer until 2.6.25. With 2.6.26 and 2.6.27-rc1, it's always on.
>
> Configs can be found here:
> <http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.25.13.config>
> <http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.26.config>
> <http://www-user.tu-chemnitz.de/~stefb/rt61pci_led/2.6.27-rc1.config>

I'm sorry, it's not a regression, just yet another config-issue. I forgot to 
set CONFIG_MAC80211_LEDS and CONFIG_RT61PCI_LEDS.

Shame on me ;)
Stefan
