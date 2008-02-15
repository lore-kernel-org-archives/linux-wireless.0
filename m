Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:3163 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761270AbYBOGO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 01:14:58 -0500
Subject: Both rt2500usb and rt73 claim USB device 148f:2573
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain
Date: Fri, 15 Feb 2008 01:14:56 -0500
Message-Id: <1203056096.30732.63.camel@dv> (sfid-20080215_061504_683272_AF03C42C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

My Level One WNC-0301USB v3 has USB ID 148f:2573, which is listed as
compatible both in rt2500usb.c and rt73usb.c.  It only works with rt73
but not with rt2500usb.

Is this duplication intentional?

I'm looking at the current wireless-2.6/everything

-- 
Regards,
Pavel Roskin
