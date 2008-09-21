Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:41135 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbYIUVNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 17:13:19 -0400
Date: Mon, 22 Sep 2008 01:12:21 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	reinette.chatre@intel.com, jgarzik@pobox.com,
	linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921211221.GD2135@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru> <1222025731.6782.117.camel@californication>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1222025731.6782.117.camel@californication>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel.

On Sun, Sep 21, 2008 at 09:35:31PM +0200, Marcel Holtmann (holtmann@linux.intel.com) wrote:
> I don't know if it is for this bug or a different one, but Matthew
> Garrett seem to have some pending patches. At least that is what he told
> me at PlumbersConf. Lets see if these patches do help. And please follow
> up with Arjan's suggestion and put a WARN_ON in the upstream code
> instead of waving CONFIG_BROKEN around.

I expect it is something new, since this bug exists at least from the
1.2 firmware version and .11 kernel. It was also reproduced (long ago
though) on 2.4.

-- 
	Evgeniy Polyakov
