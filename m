Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60967 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYIYXOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 19:14:51 -0400
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
From: Pavel Roskin <proski@gnu.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48DBE5E8.2000507@hauke-m.de>
References: <48DBE5E8.2000507@hauke-m.de>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 19:14:49 -0400
Message-Id: <1222384489.23232.37.camel@dv> (sfid-20080926_011455_900852_08D51F2C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 21:26 +0200, Hauke Mehrtens wrote:
> After upgrading from wireless-testing-2008-09-12 to
> wireless-testing-2008-09-24 I got the following kernel panic short after
> starting linux.

Same thing here.  Also in ieee80211_select_queue.  Fedora Development,
x86_64, current wireless-testing/master.  The system where it happens
has b43, b43legacy and rt61pci compiled as modules, they all are loaded
on startup, and there are supported cards for all of them.

Due to a finicky video card, I cannot use more than 25 lines on the
terminal, so I don't see if there is a BUG before the trace in my case.

-- 
Regards,
Pavel Roskin
