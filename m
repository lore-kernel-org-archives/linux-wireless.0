Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cliff.cs.toronto.edu ([128.100.3.120]:42549 "EHLO
	cliff.cs.toronto.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab0BIQZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 11:25:30 -0500
To: Dan Williams <dcbw@redhat.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] airo: fix WEP key clearing after c0380693520b1a1e4f756799a0edc379378b462a 
In-reply-to: dcbw's message of Mon, 08 Feb 2010 15:47:11 -0800.
             <1265672831.15235.43.camel@localhost.localdomain>
Date: Tue, 09 Feb 2010 11:25:28 -0500
From: Chris Siebenmann <cks@cs.toronto.edu>
Message-Id: <20100209162528.78B652B0067@apps0.cs.toronto.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 So that I don't forget this again:
| Also, what firmware version do you have?

 The driver reports:
airo(): Probing for PCI adapters
airo 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
airo(): Found an MPI350 card
airo(eth1): Firmware version 5.41.00
airo(eth1): WPA supported.
airo(eth1): MAC enabled 00:0e:9b:90:af:29

	- cks
