Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45207
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbYJ2FH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 01:07:56 -0400
Date: Tue, 28 Oct 2008 22:07:33 -0700 (PDT)
Message-Id: <20081028.220733.88410572.davem@davemloft.net> (sfid-20081029_060759_941937_8ACCCAAA)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: clean up sysfs code using %pM
From: David Miller <davem@davemloft.net>
In-Reply-To: <1225198854.3598.6.camel@johannes.berg>
References: <1225198854.3598.6.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 28 Oct 2008 14:00:54 +0100

> Remove converting the MAC address to a string by a direct byte
> conversion and use %pM instead, since the code is now boilerplate
> use a macro to define the show functions, and also use the shorter
> __ATTR_RO macro to define the attributes.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> John, just FYI, it needs to go through net-next-2.6 since it depends on
> %pM. Won't cause conflicts either :)

I'll let John get this one.
