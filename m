Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:33022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761265Ab0J0PNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 11:13:51 -0400
Subject: Re: [RFC] iwlwifi: jiffies based tx queues watchdog
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1288191304-6177-1-git-send-email-sgruszka@redhat.com>
References: <1288191304-6177-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 08:11:07 -0700
Message-ID: <1288192267.12056.75.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanistaw,

On Wed, 2010-10-27 at 07:55 -0700, Stanislaw Gruszka wrote:
> This patch replace monitor/recover timer by watchdog based on time
> stamp. New code allow to discover hangs more precisely.
> 
> Timeout values are currently doubled monitoring period values of
> previous timer. This have to be tuned based of firmware timing
> capabilities.
> 
> Code was not widely tested jet.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

Thanks for the RFC, I will have people here test this patch with the
latest devices still under development. At the meantime, could you also
do some testing on your side with the devices you have since we can not
cover all the older devices already out there.

Thanks
Wey

