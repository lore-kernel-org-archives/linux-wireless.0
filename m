Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0JYOsN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:48:13 -0400
Subject: Re: [PATCH 4/7] iwlwifi: avoid commit rxon during scan in
 iwlagn_configure_filter
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-4-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287759870-5758-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:47:22 -0700
Message-Id: <1288018042.3435.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> Almost anywhere in the code we avoid committing rxon while performing
> scan, and make rxon commit when scan complete. However in some places
> in the code we do not follow that rule. This patch fix that problem in
> iwlagn_configure_filter().
> 
> Since we do not commit directly in iwl3945_configure_filter, we can
> also do the same for agn, so I just remove iwlcore_commit_rxon()
> function and add a comment. Also change comment for iwl3945.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


