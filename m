Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1L0Kxm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 05:53:42 -0500
Date: Tue, 27 Dec 2011 11:53:40 +0100
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: iwl3945 didn't survive after s2ram failure
Message-ID: <20111227105340.GD5344@tiehlicka.suse.cz> (sfid-20111227_115412_472012_7C345E72)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
my laptop died (due to drained batteries) while it was suspended to
RAM and the wireless didn't get back to life after I booted again.
Dmesg says:
cfg80211: Calling CRDA to update world regulatory domain
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, in-tree:s
iwl3945: Copyright(c) 2003-2011 Intel Corporation
iwl3945 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
iwl3945 0000:05:00.0: setting latency timer to 64
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: MAC is in deep sleep!.  CSR_GP_CNTRL = 0xFFFFFFFF
iwl3945 0000:05:00.0: bad EEPROM signature,EEPROM_GP=0x00000007
iwl3945 0000:05:00.0: EEPROM not found, EEPROM_GP=0xffffffff
iwl3945 0000:05:00.0: Unable to init EEPROM
iwl3945 0000:05:00.0: PCI INT A disabled
iwl3945: probe of 0000:05:00.0 failed with error -2

Is there anything I can do to resurrect it?

Thanks a lot
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
