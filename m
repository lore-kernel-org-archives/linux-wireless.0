Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:58262 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3I3QMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 12:12:53 -0400
Message-ID: <5249A2F7.5090908@einfach.org> (sfid-20130930_181257_909180_DD3D27EF)
Date: Mon, 30 Sep 2013 17:12:39 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org, sujith@msujith.org
CC: Ingo Randolf <ingo.randolf@qupik.com>
Subject: Re: ath9k AR9287 status?
References: <52492FB0.3010201@einfach.org> <5249443E.3080700@rempel-privat.de> <524954BE.8060603@einfach.org> <52497C2E.1060406@rempel-privat.de>
In-Reply-To: <52497C2E.1060406@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2013 02:27 PM, Oleksij Rempel wrote:
>>> Check:
>>> - PCIe related power managment - ASPM.

Hmm, disabling ASPM in the BIOS and per kernel command line 
(pcie_aspm=off) did not help.

> I use 3.11 right now. In case of PCIe issue, backport wont help you.
> Test completely new kernel.

I'll try 3.11 later.

> What is your host hardware?

Its a Advantech MIO-2261N (Atom N260).

Thanks,
bruno
