Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-5.dex002.intermedia.net ([64.78.21.20]:42613 "EHLO
	dhost002-5.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263AbXEJRZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:25:50 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 10 May 2007 10:26:03 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: Specifing rate control algorithm?
Message-ID: <20070510172603.GF24712@devicescape.com>
References: <464253CE.2030504@linux.intel.com> <20070510132756.2ca660a0@midnight.suse.cz> <46434596.6010908@linux.intel.com> <1178817104.3806.33.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178817104.3806.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2007 at 07:11:44PM +0200, Johannes Berg wrote:

> Why don't we just add a char *preferred_rate_control; to the hw
> definition structure instead? That way, we can even show it in
> sys/debugfs later so the user will still know what the driver preferred
> after changing it.

This would be my preference, too.

-- 
Jouni Malinen                                            PGP id EFC895FA
