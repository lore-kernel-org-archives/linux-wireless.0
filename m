Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbXITASC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 20:18:02 -0400
Date: Wed, 19 Sep 2007 17:18:01 -0700 (PDT)
Message-Id: <20070919.171801.98863433.davem@davemloft.net>
To: larry.finger@lwfinger.net
Cc: joe@perches.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: net-2.6.24 - build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <46F1BAA7.9080701@lwfinger.net>
References: <1190238802.26101.24.camel@localhost>
	<20070919.151712.66176476.davem@davemloft.net>
	<46F1BAA7.9080701@lwfinger.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry Finger <larry.finger@lwfinger.net>
Date: Wed, 19 Sep 2007 19:11:19 -0500

> The patch below was sent to John Linville yesterday. Obviously, it
> didn't get included before he pushed to you. With this patch, all
> the debugfs names become static, and avoid the namespace clash with
> b43. In addition, Michael Buesch has a similar patch pending for
> b43.

I've applied this patch and if someone sends me the b43 patch
I'll apply that one too.

Thanks Larry!
