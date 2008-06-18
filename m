Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43889
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754273AbYFRFfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 01:35:55 -0400
Date: Tue, 17 Jun 2008 22:35:55 -0700 (PDT)
Message-Id: <20080617.223555.226018311.davem@davemloft.net> (sfid-20080618_073601_309997_A9751720)
To: davej@codemonkey.org.uk
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [Bug 451804] New: kernel: KERNEL: assertion (flags & MSG_PEEK)
 failed at net/ipv4/tcp.c (1354)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080617144056.GA19275@codemonkey.org.uk>
References: <20080617144056.GA19275@codemonkey.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dave Jones <davej@codemonkey.org.uk>
Date: Tue, 17 Jun 2008 10:40:56 -0400

> This one been reported yet ?

Looks to be an ath5k specific problem based upon other
reports I was able to find.

For example, have a look at the "Transfers stall with ath5k
on compat-wireless drivers" thread on the ath5k-devel list:

http://kerneltrap.org/mailarchive/linux-ath5k-devel/2008/6/4/2028874

linux-wireless added to CC.

