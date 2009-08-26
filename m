Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63545 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151AbZHZUZ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 16:25:57 -0400
Subject: Re: [PATCH] iwlwifi: fix ICT irq table endianness
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1251317713.14690.0.camel@johannes.local>
References: <1251317713.14690.0.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 13:25:47 -0700
Message-Id: <1251318347.30019.14637.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-26 at 13:15 -0700, Johannes Berg wrote:
> The ICT IRQ table is a set of __le32 values, not u32 values,
> so when reading it we need to take into account that it has
> to be converted to CPU endianness. This was causing a lot of
> trouble on my powerpc box where various things would simply
> not work for no apparent reason with 5xxx cards, but worked
> with 4965 -- which doesn't use the ICT table.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


