Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54317 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2EJGpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 02:45:07 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC/PATCH] multi-channel preparation work
Date: Thu, 10 May 2012 08:44:35 +0200
Message-ID: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com> (sfid-20120510_084524_712877_F7A4C0BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Here's some work on multi-channel operation. It refactors channel
switching logic with regard to ieee80211_hw_config and moves
oper_channel stuff to sdata.

I plan on doing channel contexts next. Monitor interface stuff probably
needs to be addressed as well since it's tied tightly with set_channel.


--
Pozdrawiam / Best regards, Michal Kazior.

