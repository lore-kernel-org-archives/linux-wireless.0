Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58955
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbYAZNtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2008 08:49:33 -0500
Date: Sat, 26 Jan 2008 05:49:47 -0800 (PST)
Message-Id: <20080126.054947.105447808.davem@davemloft.net> (sfid-20080126_134937_101371_9472CA20)
To: linville@tuxdriver.com
Cc: mb@bu3sch.de, inaky@linux.intel.com, torvalds@linux-foundation.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080125214626.GG14687@tuxdriver.com>
References: <200801251311.45392.inaky@linux.intel.com>
	<200801252221.07558.mb@bu3sch.de>
	<20080125214626.GG14687@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 25 Jan 2008 16:46:26 -0500

> Plus it is a bit unfair to ask for firmware changes just because the
> vendor is actually engaged with us.  If this were Broadcom or Zydas
> firmware we would have little recourse other than to accept it or
> fix it in the driver or stack.

It's funny that you mention Broadcom, because on the ethernet
side exactly because they engage with us I've been able to
get them to add things that make sense to their gigabit firmware
and even the hardware itself.

It's the only reason Broadcom's gigabit and faster chips have
the one-shot MSI feature, because I asked them to add it because
it makes NAPI significantly faster.
