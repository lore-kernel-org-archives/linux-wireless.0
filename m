Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56565 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab1JLSas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:30:48 -0400
Date: Wed, 12 Oct 2011 14:24:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/34] update for 3.2
Message-ID: <20111012182440.GD18764@tuxdriver.com> (sfid-20111012_203052_663221_209E01BA)
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 07:26:45AM -0700, Wey-Yi Guy wrote:
> We address the performance issue cause by earlier path which disable too many calibration.
> We include few more bugs fix and enhancement patches for WoWLAN operations
> We continue remove un-needed code and clean up after driver split
> We also include new SKUs for both 6005 and 105 series of devices

Applying: iwlagn: separate init calib and rt calib
error: patch failed: drivers/net/wireless/iwlwifi/iwl-agn.c:1222
error: drivers/net/wireless/iwlwifi/iwl-agn.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-commands.h:3216
error: drivers/net/wireless/iwlwifi/iwl-commands.h: patch does not apply

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
