Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39604
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752961AbZCVF5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 01:57:07 -0400
Date: Sat, 21 Mar 2009 22:56:54 -0700 (PDT)
Message-Id: <20090321.225654.150752910.davem@davemloft.net> (sfid-20090322_065711_764187_CDB28D87)
To: shemminger@vyatta.com
Cc: jkosina@suse.cz, dstreba@suse.cz, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 72/77] ipw2x00: convert infrastructure for use by
 net_device_ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090321053718.065171867@vyatta.com>
References: <20090321053527.316395697@vyatta.com>
	<20090321053718.065171867@vyatta.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Fri, 20 Mar 2009 22:36:39 -0700

> Expose routines so drivers can hook. Only set ptrs in netdev
> if using old compat code.
> 
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

Applied.
