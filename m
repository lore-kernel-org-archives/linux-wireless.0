Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from complete.lackof.org ([198.49.126.79]:59747 "EHLO
	complete.lackof.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3EVULE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 16:11:04 -0400
From: Matt Taggart <taggart@debian.org>
To: linux-wireless@vger.kernel.org
cc: 709364@bugs.debian.org
Subject: iwlwifi: problems with Intel 6235
Date: Wed, 22 May 2013 13:01:49 -0700
Message-Id: <20130522200149.90BD2153@taggart.lackof.org> (sfid-20130522_221108_274333_45C9CBA4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am seeing problems with the "Intel Corporation Centrino Advanced-N
6235 [8086:088e]" card in my laptop.

When connected to a particular access point using 802.11n I get
frequent disconnects, dropped packets, erratic latency, and slow
data rates. Some access points don't have the problem.

I have tested both the Debian wheezy (3.2.41 based) and sid (3.8.13
based) kernels and both have the problems.

I reported the problem and details to the Debian BTS here

  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=709364

(cc'd) and I think it's the same problem as this ubuntu bug

  https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836250

Let me know if you want me to try anything or need me to send more
info.

Thanks,

-- 
Matt Taggart
taggart@debian.org
