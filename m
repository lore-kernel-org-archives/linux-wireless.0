Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47982 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0LCQRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 11:17:18 -0500
Subject: Re: [PATCH 2/2] iwlwifi: jiffies based tx queues watchdog
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291387308-5829-2-git-send-email-sgruszka@redhat.com>
References: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
	 <1291387308-5829-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 08:16:11 -0800
Message-Id: <1291392971.1445.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-03 at 06:41 -0800, Stanislaw Gruszka wrote:
> This patch replace monitor/recover timer by watchdog based on time
> stamp. New code allow to discover hangs more precisely.
> 
> Timeout values are currently doubled monitoring period values of
> previous timer. This have to be tuned based of firmware timing
> capabilities.
> 
> Tested on 3945, 4965, 5300, 6300.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>


I did some initial test on the newer (WiFi/BT combo) devices and look
ok. Of cause, I just did very minimal test.

Wey

