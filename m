Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38784
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbZFSHPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 03:15:46 -0400
Date: Fri, 19 Jun 2009 00:15:50 -0700 (PDT)
Message-Id: <20090619.001550.221952447.davem@davemloft.net>
To: david-b@pacbell.net
Cc: jussi.kivilinna@mbnet.fi, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] usbnet: Add stop function pointer to 'struct
 rndis_data'.
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906182217.38049.david-b@pacbell.net>
References: <20090616141721.23639.15379.stgit@fate.lan>
	<20090616141727.23639.22861.stgit@fate.lan>
	<200906182217.38049.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Brownell <david-b@pacbell.net>
Date: Thu, 18 Jun 2009 22:17:37 -0700

> On Tuesday 16 June 2009, Jussi Kivilinna wrote:
>> Allow minidriver to know that netdev has stopped. This is to let
>> wireless turn off radio when usbnet dev is stopped.
>> 
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> CC: David Brownell <dbrownell@users.sourceforge.net>
> 
> Acked-by: David Brownell <dbrownell@users.sourceforge.net>

Acked-by: David S. Miller <davem@davemloft.net>

John please take this into your wireless tree if you haven't
already.

Thanks!
