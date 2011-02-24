Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:45120 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab1BXPfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 10:35:13 -0500
Subject: Re: [PATCH] iwlegacy: do not set tx power when channel is changing
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298553835-5821-1-git-send-email-sgruszka@redhat.com>
References: <1298553835-5821-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 07:20:20 -0800
Message-ID: <1298560820.5138.37.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-24 at 05:23 -0800, Stanislaw Gruszka wrote:
> Same fix as f844a709a7d8f8be61a571afc31dfaca9e779621
> "iwlwifi: do not set tx power when channel is changing".
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

> ---
>  drivers/net/wireless/iwlegacy/iwl-4965.c |    2 +-
>  drivers/net/wireless/iwlegacy/iwl-core.c |   13 ++++++++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
good catch :-), thanks
Wey

