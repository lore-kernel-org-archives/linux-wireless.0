Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out8.libero.it ([212.52.84.108]:58292 "EHLO
	cp-out8.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYLXR3U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 12:29:20 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: p54: ad-hoc mode doesn't work
Date: Wed, 24 Dec 2008 18:28:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <200812230132.21839.rossi.f@inwind.it> <1230072758.5692.2.camel@dv>
In-Reply-To: <1230072758.5692.2.camel@dv>
MIME-Version: 1.0
Message-Id: <200812241828.49679.rossi.f@inwind.it> (sfid-20081224_182929_094717_66D4541B)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems strange to me, on the other PC I'm using the ath5k driver with a PCI 
wireless NIC and the interface enters in ad-hoc mode without complaining 
(CRDA is not installed).

I'll try to install also CRDA to see if something changes, maybe there is a 
difference between the ath5k and p54 drivers.

Thanks,
Fabio

On Tuesday 23 December 2008, Pavel Roskin wrote:

> Once CRDA is installed, use "iw" to set your regulatory domain.  Without
> CRDA, the kernel uses very conservative rules that don't allow beaconing
> and thus the ad-hoc mode.
