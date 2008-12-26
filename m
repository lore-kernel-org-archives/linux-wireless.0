Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51163 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYLZDGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2008 22:06:02 -0500
Subject: Re: Firmware errors with ipw2200 when connected to an WPA-enabled
	AP
From: Zhu Yi <yi.zhu@intel.com>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
	James Ketrenos <jketreno@linux.intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <495443E6.404@ionic.de>
References: <495443E6.404@ionic.de>
Content-Type: text/plain
Date: Fri, 26 Dec 2008 11:05:06 +0800
Message-Id: <1230260706.27521.15.camel@debian> (sfid-20081226_040608_292317_E8A4E388)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-12-26 at 10:39 +0800, Mihai Moldovan wrote:
> So, I am really curious about this, although not being fatal in
> itself,
> the errors are pretty annoying.

The fatal error is from the perspective of the driver. It is handled
transparent to the users now except the error logs.

> Another little question: will the card be supported by the new
> iwlwifi/iwlcore/iwlagn drivers anytime soon, or will the "old" ipw2200
> driver be the only one for this card?

No, iwlagn won't support ipw2200 because of the design difference.

> Someone really should update the
> documentation, at least in the kernel build system regarding this,
> currently "There is no help available." :)

I think John is working on reordering the ipw2100/2200 to ipw2x00 folder
which is parallel to iwlwifi.

Thanks,
-yi

