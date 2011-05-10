Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753645Ab1EJOTW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 10:19:22 -0400
Subject: Re: [PATCH 2.6.38] iwlwifi: add {ack,plpc}_check module parameters
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1304968953-27663-1-git-send-email-sgruszka@redhat.com>
References: <1304968953-27663-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 07:16:15 -0700
Message-ID: <1305036975.4960.5.camel@wwguy-ubuntu> (sfid-20110510_161925_636744_F9786820)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 12:22 -0700, Stanislaw Gruszka wrote:
> commit b7977ffaab5187ad75edaf04ac854615cea93828 upstream.
> 
> Add module ack_check, and plcp_check parameters. Ack_check is disabled
> by default since is proved that check ack health can cause troubles.
> Plcp_check is enabled by default.
> 
> This prevent connection hangs with "low ack count detected" messages.
> 
> Resolves:
> https://bugzilla.redhat.com/show_bug.cgi?id=666646
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    1 +
>  drivers/net/wireless/iwlwifi/iwl-agn.c     |    6 ++++++
>  drivers/net/wireless/iwlwifi/iwl-core.h    |    2 ++
>  drivers/net/wireless/iwlwifi/iwl-rx.c      |    8 ++++++--
>  4 files changed, 15 insertions(+), 2 deletions(-)
> 


