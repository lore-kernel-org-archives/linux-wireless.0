Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYGGIAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 04:00:04 -0400
Subject: Re: 2.6.26: iwl4965 problems changing interface mode
From: Zhu Yi <yi.zhu@intel.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <486EAD93.5060109@gentoo.org>
References: <486EAD93.5060109@gentoo.org>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 15:58:02 +0800
Message-Id: <1215417482.14590.747.camel@debian.sh.intel.com> (sfid-20080707_100010_277831_66EDC0B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-04 at 18:09 -0500, Daniel Drake wrote:
> # ifconfig wlan0 up
> 
> iwl4965: U iwl4965_mac_start enter
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
> PM: Writing back config space on device 0000:03:00.0 at offset 1 (was 
> 100102, writing 100106)
> iwl4965: Radio disabled by SW RF kill (module parameter)
> ACPI: PCI interrupt for device 0000:03:00.0 disabled
> iwl4965: U iwl4965_mac_start leave - failed
> 
> It's interesting how RF kill plays into it. I definitely didn't press 
> the RF kill switch.

I don't see this problem from my side. Do you have some wireless scripts
hook the interface event and issues a `iwconfig wlan0 txpower off` in
turn? Please see if it is the case with the iwconfig Tx-power entry
result.

Thanks,
-yi

