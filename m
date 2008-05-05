Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58607 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYEETkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 15:40:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Jt6Xa-0007Or-Ty
	for linux-wireless@vger.kernel.org; Mon, 05 May 2008 19:40:02 +0000
Received: from 78-62-85-225.static.zebra.lt ([78.62.85.225])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 19:40:02 +0000
Received: from paulius.zaleckas by 78-62-85-225.static.zebra.lt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2008 19:40:02 +0000
To: linux-wireless@vger.kernel.org
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [PATCH] 8139too: use netstats in net_device structure
Date: Mon, 05 May 2008 22:37:24 +0300
Message-ID: <481F61F4.8000809@teltonika.lt> (sfid-20080505_213922_682577_6FB56230)
References: <fvnmeu$jt5$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: netdev@vger.kernel.org
In-Reply-To: <fvnmeu$jt5$1@ger.gmane.org>
Cc: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paulius Zaleckas wrote:
> Use net_device_stats from net_device structure instead of local.
> Changed airo_read_stats function parameter to net_device.
> 
> Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 

Sorry. Posted with wrong subject(copy & paste error)...
I will repost it.

