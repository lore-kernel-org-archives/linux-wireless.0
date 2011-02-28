Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008Ab1B1Pg6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 10:36:58 -0500
Subject: Re: [PATCH v3 4/5] iwlwifi: move check health code into iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298899997-2372-4-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
	 <1298899997-2372-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 07:18:06 -0800
Message-ID: <1298906286.5082.77.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 05:33 -0800, Stanislaw Gruszka wrote:
> Remove check_plcp_health and check_ack_health ops methods, they are
> unneeded after iwlegacy driver split. Merge check health code into to
> iwl-rx.c and make functions static.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


