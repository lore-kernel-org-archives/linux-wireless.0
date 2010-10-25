Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39953 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab0JYOrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 10:47:23 -0400
Subject: Re: [PATCH 2/7] iwlwifi: send tx_power_cmd synchronously
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-2-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
	 <1287759870-5758-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Mon, 25 Oct 2010 07:46:32 -0700
Message-Id: <1288017992.3435.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> On 5xxx and 6xxx change to send tx_power_cmd command synchronously,
> to do not start other commands when setting tx power is pending.
> We currently do the same for 4956 and 3945.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by:  Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---


