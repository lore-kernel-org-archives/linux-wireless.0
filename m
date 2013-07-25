Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elwsc.co.jp ([27.50.121.29]:54519 "EHLO elwsc.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab3GYMhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jul 2013 08:37:55 -0400
Received: from [192.168.0.199] (p2192-ipbf202hodogaya.kanagawa.ocn.ne.jp [221.191.33.192])
	(authenticated bits=0)
	by elwsc.co.jp (8.14.5/8.14.5) with ESMTP id r6PC2lhU009597
	for <linux-wireless@vger.kernel.org>; Thu, 25 Jul 2013 21:02:49 +0900
Date: Thu, 25 Jul 2013 21:02:51 +0900
From: KATSUMI masanori <masanori-katsumi@elwsc.co.jp>
To: linux-wireless@vger.kernel.org
Subject: How to read WiFi radio frequency.
Message-Id: <20130725210249.89DD.635158EF@elwsc.co.jp> (sfid-20130725_143758_484049_47990893)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to make p2p software with the current device as the group
owner.
I would like to acquire the channel that GO started, from normal user(NOT
root).
How can I get this information?

