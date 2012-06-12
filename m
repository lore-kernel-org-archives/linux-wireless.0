Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54755 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2FLVKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 17:10:52 -0400
Received: from pyramind.ukuu.org.uk (earthlight.etchedpixels.co.uk [81.2.110.250])
	by lxorguk.ukuu.org.uk (8.14.5/8.14.1) with ESMTP id q5CLeNCH032638
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 22:40:28 +0100
Received: from pyramind.ukuu.org.uk (localhost [127.0.0.1])
	by pyramind.ukuu.org.uk (8.14.5/8.14.5) with ESMTP id q5CLEWVf004210
	for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 22:14:33 +0100
Date: Tue, 12 Jun 2012 22:14:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-wireless@vger.kernel.org
Subject: 3.5-rc wireless breakage
Message-ID: <20120612221431.2131d6fe@pyramind.ukuu.org.uk> (sfid-20120612_231057_443094_D98F8CBC)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boot hangs and eventually the watchdog kicks in with the following trace


__delay
__const_udelay
ar9003_get_pll_sqsum_dvc
ath_hw_pll_work
process_one_work
ath_tx_complete_poll_work


Platform is an HP Mini-210-4i


Is this a known bug or does it warrant more digging ?

Alan
