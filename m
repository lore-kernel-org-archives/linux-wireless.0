Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0JYOsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:48:30 -0400
Subject: Re: [PATCH 5/7] iwlwifi: avoid commit rxon during scan in
 iwlagn_bt_traffic_change_work
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-5-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287759870-5758-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:47:40 -0700
Message-Id: <1288018060.3435.11.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> Avoid sending commands to firmware (including commit_rxon) when scan
> is pending and we are calling iwlagn_bt_traffic_change_work simultaneously.
> 
> Also comment some innocent race conditions.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


