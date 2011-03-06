Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1CFVuD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 16:50:03 -0500
Subject: Re: [PATCH 1/3] iwlwifi: move rx handlers code to iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Mar 2011 13:34:18 -0800
Message-ID: <1299447258.5082.164.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-03-04 at 08:51 -0800, Stanislaw Gruszka wrote:
> Put generic rx_handlers (except iwlagn_rx_reply_compressed_ba) to
> iwl-rx.c . Make functions static and change prefix from iwlagn_ to
> iwl_ . Beautify iwl_setup_rx_handlers and do some other minor coding
> style changes.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
this patch break the compiling

drivers/net/wireless/iwlwifi/iwl-rx.c:778:17: error: undefined
identifier 'TASK_INTERRUPTIBLE'
  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
drivers/net/wireless/iwlwifi/iwl-rx.c: In function
‘iwl_rx_card_state_notif’:
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
appears in.)
make[1]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
make: *** [_module_drivers/net/wireless/iwlwifi] Error 2


Thanks
Wey

