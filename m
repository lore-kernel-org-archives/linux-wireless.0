Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53044
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbYEEUEv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 16:04:51 -0400
Date: Mon, 05 May 2008 13:04:50 -0700 (PDT)
Message-Id: <20080505.130450.88118119.davem@davemloft.net> (sfid-20080505_220408_549463_5139AB67)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] allow netdevices to specify needed head/tailroom
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209992486.8245.14.camel@johannes.berg>
References: <1209992486.8245.14.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Mon, 05 May 2008 15:01:26 +0200

> Forgot again to post this this morning, sorry.
> 
> This patch adds needed_headroom/needed_tailroom members to struct
> net_device and updates many places that allocate sbks to use them. Not
> all of them can be converted though, and I'm sure I missed some (I
> mostly grepped for LL_RESERVED_SPACE)

Thanks for working on this patch, I'll review it today some
time.
