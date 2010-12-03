Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:42445 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab0LCQSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 11:18:05 -0500
Subject: Re: [PATCH 1/2] iwl3945: prevent too frequent firmware resets
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
References: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 08:16:58 -0800
Message-Id: <1291393018.1445.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-03 at 06:41 -0800, Stanislaw Gruszka wrote:
> Similarly like on iwlagn, initialize reset duration on iwl3945 to prevent
> too frequent firmware resets.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

