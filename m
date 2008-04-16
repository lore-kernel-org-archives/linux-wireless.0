Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41857 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbYDPAoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 20:44:22 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 0/11] iwlwifi driver updates
Date: Tue, 15 Apr 2008 17:44:21 -0700
Message-ID: <D936D925018D154694D8A362EEB089200430E7BC@orsmsx416.amr.corp.intel.com> (sfid-20080416_014431_254073_45208135)
In-Reply-To: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
References: <1208300507-25628-1-git-send-email-reinette.chatre@intel.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 15, 2008 4:02 PM, Chatre, Reinette  wrote:

> This series contains various iwlwifi updates and two bugfixes (#8 and
> #10). 
> 
> [PATCH 01/11] iwlwifi: remove the statistics work
> [PATCH 02/11] iwlwifi: hw_setting cleanup
> [PATCH 03/11] iwlwifi: support different num of tx and rx antennas
> [PATCH 04/11] iwlwifi: move the creation of LQ host command to iwlcore
> [PATCH 05/11] iwlwifi: move HW device registration
> [PATCH 06/11] iwlwifi: introduce host commands callbacks
> [PATCH 07/11] iwlwifi: move rxon associated command to hcmd
> [PATCH 08/11] iwlwifi: Fix TKIP update key and get_free_ucode_key
> [PATCH 09/11] iwlwifi: arrange max number of Tx queues
> [PATCH 10/11] iwlwifi: fix unload warning and error
> [PATCH 11/11] iwlwifi: Use HW acceleration decryption by default
> 

Weird ... this email is showing up as part of a different thread that
had the same title. I don't know how to fix that as I used
git-send-email to send out this patch series standalone ... not as a
reply to anything. Sorry for any confusion it may have caused.

Reinette

