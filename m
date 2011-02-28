Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37958 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab1B1Pct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 10:32:49 -0500
Subject: Re: [PATCH v3 2/5] iwlegacy: fix dma mappings and skbs leak
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298899997-2372-2-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
	 <1298899997-2372-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 07:16:10 -0800
Message-ID: <1298906170.5082.75.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 05:33 -0800, Stanislaw Gruszka wrote:
> Fix possible dma mappings and skbs introduced by commit
> 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7 "iwlwifi: avoid Tx queue
> memory allocation in interface down".
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


