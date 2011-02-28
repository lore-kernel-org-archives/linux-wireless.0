Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36290 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab1B1PfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 10:35:09 -0500
Subject: Re: [PATCH v3 5/5] iwlwifi: move remaining iwl-agn-rx.c code into
 iwl-rx.c
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
References: <1298899997-2372-1-git-send-email-sgruszka@redhat.com>
	 <1298899997-2372-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 07:19:55 -0800
Message-ID: <1298906395.5082.78.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 05:33 -0800, Stanislaw Gruszka wrote:
> There is no need to have separate iwl-agn-rx.c file after iwlegacy
> split.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


