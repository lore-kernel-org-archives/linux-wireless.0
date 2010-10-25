Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22460 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab0JYOtF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:49:05 -0400
Subject: Re: [PATCH 7/7] iwlwifi: avoid commit rxon during scan in
 iwl_set_no_assoc
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-7-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287759870-5758-7-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:48:14 -0700
Message-Id: <1288018094.3435.13.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> Currently we are canceling scan when changing BSSID. Behave the same
> when changing association and beacon enablement, to avoid committing
> rxon during scan in iwl_set_no_assoc().
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


