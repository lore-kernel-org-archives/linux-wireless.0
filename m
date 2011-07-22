Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab1GVNbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 09:31:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>
Subject: [RFC/RFT 0/6] ath9k: ASPM fixes
Date: Fri, 22 Jul 2011 15:31:46 +0200
Message-Id: <1311341512-2882-1-git-send-email-sgruszka@redhat.com> (sfid-20110722_153106_345288_4F2A0270)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series try to fix ath9k ASPM (but some some of them
are cleanup only patches).

Patches do not cope with situation when CONFIG_PCIEASPM
is enabled and ASPM settings can be changed dynamically via 
/sys/module/pcie_aspm/parameters/policy
I hope I will address that soon.

These patches needs wide testing as they may work on some systems
and not work on others, that can depend on PCIe bridges.

Stanislaw

