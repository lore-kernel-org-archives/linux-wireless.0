Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:21666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbYL2WVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 17:21:52 -0500
Received: by rv-out-0506.google.com with SMTP id k40so4575784rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 14:21:51 -0800 (PST)
Date: Mon, 29 Dec 2008 17:21:06 -0500
From: Michael Gilbert <michael.s.gilbert@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: reducing the priority of orinoco.c link status messages
Message-Id: <20081229172106.e680ccf1.michael.s.gilbert@gmail.com> (sfid-20081229_232156_287097_2D831034)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hello, i am at a location where a nearby wireless router comes in and out of
range, so i get a ton of "eth2: New link status: AP Out of Range (0004)" 
and "eth2: New link status: AP In Range (0005)" messages on the active 
terminal.  this makes it difficult to work (especially in vi).

i've found that orinoco.c contains the code that prints these messages.  would it be possible/reasonable to use the KERN_DEBUG or lower printk level instead of KERN_INFO for this specific information?

this problem was also submitted to debian's bts, see [1].

please cc me on any replies as i am not subscribed to this list.  thank you.

mike

[1] http://bugs.debian.org/447549
