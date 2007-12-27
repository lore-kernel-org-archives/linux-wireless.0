Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbXL0J1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2007 04:27:03 -0500
Date: Thu, 27 Dec 2007 01:26:56 -0800 (PST)
Message-Id: <20071227.012656.59032711.davem@davemloft.net> (sfid-20071227_092709_699536_CEAD26F0)
To: mokuno@sm.sony.co.jp
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: : Emit event stream compat iw_point objects correctly.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071227181439.6F59.40F06B3A@sm.sony.co.jp>
References: <20071227173802.6F56.40F06B3A@sm.sony.co.jp>
	<20071227.005725.144782426.davem@davemloft.net>
	<20071227181439.6F59.40F06B3A@sm.sony.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Date: Thu, 27 Dec 2007 18:24:40 +0900

> On ppc64 (PS3), IW_EV_LCP_LEN is 8, not 4.
> 
> include/linux/wireless.h:
> 
> #define IW_EV_LCP_LEN   (sizeof(struct iw_event) - sizeof(union iwreq_data))
> 
> where sizeof(struct iw_event) == 24, sizeof(union iwreq_data) == 16 on
> PS3.

Hmmm, I will look into this, thank you :-)
