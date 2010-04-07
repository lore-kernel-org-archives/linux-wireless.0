Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23649 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab0DGJhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Apr 2010 05:37:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Apr 2010 02:37:13 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19388.22296.196628.670656@gargle.gargle.HOWL>
Date: Wed, 7 Apr 2010 15:27:44 +0530
To: Ming Lei <tom.leiming@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath9k_htc: Protect RX stream variables
In-Reply-To: <n2gd82e647a1004062351o1d7c68c7j79c6bf253363254b@mail.gmail.com>
References: <19387.1459.438884.832345@gargle.gargle.HOWL>
	<p2od82e647a1004060618vc8b95400hbaf1cfaecc2defd3@mail.gmail.com>
	<19388.4470.438422.209224@gargle.gargle.HOWL>
	<n2gd82e647a1004062351o1d7c68c7j79c6bf253363254b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ming Lei wrote:
> I am not sure if the same irq handler can run concurrently on different CPUs.
> Even though it is, ehci/uhci handler have done such protection, so it
> is not necessary to add such protection in the complete handler of usb
> interface driver.

What protection is done by ehci ?
Is more information on this available anywhere ?

Sujith
