Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43022
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751359AbXISUMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 16:12:07 -0400
Date: Wed, 19 Sep 2007 13:12:06 -0700 (PDT)
Message-Id: <20070919.131206.102575245.davem@davemloft.net>
To: mb@bu3sch.de
Cc: linville@tuxdriver.com, jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070919.125641.62342823.davem@davemloft.net>
References: <20070919.115903.75429061.davem@davemloft.net>
	<200709192123.16884.mb@bu3sch.de>
	<20070919.125641.62342823.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Miller <davem@davemloft.net>
Date: Wed, 19 Sep 2007 12:56:41 -0700 (PDT)

> I agreed with John to merge this in myself, but this patch
> applied to the old driver aparently, not the new z1211 one.
> 
> Can you resend this patch against the new driver so I can
> add it to net-2.6.24?

Nevermind, John showed me that if I just edit the paths
in the patch it applied cleanly.

So I did that and pushed it to net-2.6.24, thanks!
