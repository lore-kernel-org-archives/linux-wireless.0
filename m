Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48432 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755304AbYBSWav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2008 17:30:51 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Recent driver in linux kernel 2.6.25-rc2
Date: Tue, 19 Feb 2008 14:28:58 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com> (sfid-20080219_223056_756483_A0AFD160)
In-Reply-To: <20080219153910.GA4303@ics.muni.cz>
References: <20080219153910.GA4303@ics.muni.cz>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>,
	<ipw3945-devel@lists.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On , Lukas Hejtmanek  wrote:

> as of pre 2.6.25 kernels, kismet monitoring tool does not work with
> the message: # kismet
> Launching kismet_server: //usr/bin/kismet_server
> Suid priv-dropping disabled.  This may not be secure.
> No specific sources given to be enabled, all will be enabled.
> Non-RFMon VAPs will be destroyed on multi-vap interfaces (ie,
> madwifi-ng) Enabling channel hopping.
> Enabling channel splitting.
> Source 0 (iwl4965): Enabling monitor mode for iwl4965 source
> interface wlan0 channel 6...
> FATAL: Failed to set channel 6 5:Input/output error

Please load the driver with debugging enabled (debug=0x43fff) and send
us the log capturing during this kismet startup.

Thanks

Reinette
