Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36444 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616AbZAVSpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 13:45:46 -0500
Date: Thu, 22 Jan 2009 13:34:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 regression: associates but no data is transfered
Message-ID: <20090122183448.GC3646@tuxdriver.com> (sfid-20090122_194550_810004_4BC79383)
References: <87priffb95.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87priffb95.fsf@litku.valot.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 22, 2009 at 08:26:14PM +0200, Kalle Valo wrote:
> Hello,
> 
> I upgraded to the latest wireless-testing and my iwl3945 is now
> broken. It can associate but no data is transfered after that. Tried
> with open and wep modes. With dhcp I cannot get ip and with static ip
> ping to the gateway doesn't work.
> 
> Any hints?

Lots of iwlwifi stuff merged yesterday...

Chatre, Reinette (1):
      iwl3945: add debugging for wrong command queue

Helmut Schaa (2):
      iwl3945: fix some warnings when compiled without debug
      iwlagn: fix hw-rfkill while the interface is down

Jay Sternberg (4):
      iwlwifi: correct Kconfig to prevent following entries from not indenting
      iwlwifi: remove static from 5000 structures
      iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
      iwlwifi: add recognition of Intel WiFi Link 100 Series

Reinette Chatre (1):
      iwlwifi: return NETDEV_TX_OK from _tx ops

Samuel Ortiz (3):
      iwl3945: Use iwl_txq_update_write_ptr
      iwlwifi: Add TFD library operations
      iwl3945: Use iwl-hcmd host command routines

Winkler, Tomas (6):
      iwlwifi: make iwl-power.c more readable
      iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key
      iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout
      iwlwifi: kill scan39
      iwlwifi: remove unused or twice defined members in iwl_priv
      iwlwifi: eliminate power_data_39.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
