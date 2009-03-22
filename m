Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39600
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751934AbZCVF5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 01:57:00 -0400
Date: Sat, 21 Mar 2009 22:56:47 -0700 (PDT)
Message-Id: <20090321.225647.168570457.davem@davemloft.net> (sfid-20090322_065705_345440_675796DB)
To: shemminger@vyatta.com
Cc: jkosina@suse.cz, dstreba@suse.cz, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 71/77] ipw2x00: convert to internal net_device_stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090321053717.989009860@vyatta.com>
References: <20090321053527.316395697@vyatta.com>
	<20090321053717.989009860@vyatta.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:38 -0700

> Replace struct in ieee with current net_device_stats, so no longer
> need get_stats hook
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
