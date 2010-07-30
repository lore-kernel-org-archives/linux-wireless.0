Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:50357 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0G3Ox1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 10:53:27 -0400
Received: from smtp03.web.de  ( [172.20.0.65])
	by fmmailgate01.web.de (Postfix) with ESMTP id 06B3416535F0A
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jul 2010 16:53:26 +0200 (CEST)
Message-ID: <4C52E765.3080006@web.de>
Date: Fri, 30 Jul 2010 16:53:25 +0200
From: Ferdinand Rau <rauferd@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [SOLVED] Re: Bug report: Controller RESET (DMA error) long after
 connecting
References: <4375153.331710.1271156960878.JavaMail.fmail@mwmweb085> <20100413131108.GB6331@tuxdriver.com>
In-Reply-To: <20100413131108.GB6331@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

just for future reference, here is my report:

 > Chances are that your device will work in PIO mode -- you can try
 > building a kernel w/ CONFIG_B43_FORCE_PIO.
I tried that and it solved the original problem. This wasn't very
helpful though, since subsequently I ran into the
"No probe response from AP" bug, probably similar to:
https://lists.berlios.de/pipermail/bcm43xx-dev/2010-January/006762.html

Therefore I finally made the switch to 2.6.34 which solved this issue,
too. Thanks a lot for your advice and keep up the good work!!!

Regards,
Ferdinand

