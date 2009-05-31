Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58201 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZEaGuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 02:50:12 -0400
Subject: Re: [Announce] Intel Wireless Multicomm 3200 WiFi driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	 <20090526222433.GA23972@bombadil.infradead.org>
	 <1243736227.3623.180.camel@debian>
	 <43e72e890905302327x23d0479bkb825ea05832c5ffd@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 31 May 2009 14:42:06 +0800
Message-Id: <1243752126.3623.375.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-05-31 at 14:27 +0800, Luis R. Rodriguez wrote:
> 
> What is the 11n configuration on these devices? Do they have 2
> streams? Or are they just 1 stream?

It has 1x1, 1x2 and 2x2 on for both 20MHz and 40MHz channels. The
firmware HT support is not quite ready at this point. So we haven't done
anything 11n related in the driver yet.

Thanks,
-yi

