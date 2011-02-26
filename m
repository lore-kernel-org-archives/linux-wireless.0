Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:65319 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1BZFQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 00:16:07 -0500
Subject: Re: [patch] iwlwifi: remove duplicate initialization
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20110226015653.GC18043@bicker>
References: <20110226015653.GC18043@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 21:01:01 -0800
Message-ID: <1298696461.6478.1.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-02-25 at 17:56 -0800, Dan Carpenter wrote:
> rate_mask is initialized again later so this can be removed.  Btw, if 
> rate_control_send_low(sta, priv_sta, txrc) returns false, that means
> that "sta" is non-NULL.  That's why the second initialization of
> rate_mask is a little simpler than the first.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

make sense

Wey


