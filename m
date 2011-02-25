Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640Ab1BYREw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 12:04:52 -0500
Subject: Re: [PATCH 2/3] iwlegacy: fix dma mappings and skbs leak
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298649432-4416-2-git-send-email-sgruszka@redhat.com>
References: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
	 <1298649432-4416-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 08:49:53 -0800
Message-ID: <1298652593.28351.23.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 07:57 -0800, Stanislaw Gruszka wrote:
> Fix possible dma mappings and skbs introduced by commit
> 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7 "iwlwifi: avoid Tx queue
> memory allocation in interface down".
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

> ---
>  drivers/net/wireless/iwlegacy/iwl-4965-tx.c |   12 ++++-
>  drivers/net/wireless/iwlegacy/iwl-core.h    |    2 +
>  drivers/net/wireless/iwlegacy/iwl-tx.c      |   75 +++++++++++++++++---------
>  3 files changed, 62 insertions(+), 27 deletions(-)
> 


