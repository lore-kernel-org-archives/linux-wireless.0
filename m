Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50357 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0BSXcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 18:32:19 -0500
Subject: Re: [PATCH v2 3/3] iwlwifi: error checking for number of tfds in
 queue
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"stable@kernel.org" <stable@kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <1266621879.2551.2975.camel@rchatre-DESK>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
	 <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
	 <20100219203420.GO4950@tuxdriver.com>
	 <1266613164.2551.2811.camel@rchatre-DESK>
	 <1266621879.2551.2975.camel@rchatre-DESK>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 15:32:17 -0800
Message-ID: <1266622337.2551.3000.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 15:24 -0800, reinette chatre wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> When receive reply_tx and ready to decrement the count for number of
> tfds in queue, do error checking to prevent error condition and
> tfds_in_queue become negative number.
> 
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> CC: stable@kernel.org
> ---
> v2: ensure safe decrement is always done, one instance was missed in v1

I will resend this patch as part of a new series. Sorry for the noise.

Reinette


