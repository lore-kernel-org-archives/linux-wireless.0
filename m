Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43771
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbZCVFyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 01:54:07 -0400
Date: Sat, 21 Mar 2009 22:53:54 -0700 (PDT)
Message-Id: <20090321.225354.13734304.davem@davemloft.net> (sfid-20090322_065413_976866_DDF700D8)
To: shemminger@vyatta.com
Cc: mcgrof@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 68/77] prism54: convert to internal net_device_stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090321053717.765575826@vyatta.com>
References: <20090321053527.316395697@vyatta.com>
	<20090321053717.765575826@vyatta.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:35 -0700

> Also, make ethtool_ops const as it should be, and get rid
> of useless cast.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
