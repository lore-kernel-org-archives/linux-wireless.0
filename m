Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:19354 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1JLStf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:49:35 -0400
Subject: Re: [PATCH 00/34] update for 3.2
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111012182440.GD18764@tuxdriver.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20111012182440.GD18764@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 11:00:09 -0700
Message-ID: <1318442409.32488.7.camel@wwguy-huron> (sfid-20111012_204939_246654_17E75EE3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2011-10-12 at 11:24 -0700, John W. Linville wrote:
> On Mon, Oct 10, 2011 at 07:26:45AM -0700, Wey-Yi Guy wrote:
> > We address the performance issue cause by earlier path which disable too many calibration.
> > We include few more bugs fix and enhancement patches for WoWLAN operations
> > We continue remove un-needed code and clean up after driver split
> > We also include new SKUs for both 6005 and 105 series of devices
> 
> Applying: iwlagn: separate init calib and rt calib
> error: patch failed: drivers/net/wireless/iwlwifi/iwl-agn.c:1222
> error: drivers/net/wireless/iwlwifi/iwl-agn.c: patch does not apply
> error: patch failed: drivers/net/wireless/iwlwifi/iwl-commands.h:3216
> error: drivers/net/wireless/iwlwifi/iwl-commands.h: patch does not apply
> 

My mistake, I believe this patch already in the tree:
commit#af4dc88c56559c1ebf53628ddcc18dde23924e33 iwlagn: separate init
calib and rt calib


Thanks
Wey

