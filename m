Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.srv.pl ([217.17.32.250]:51987 "EHLO mail.srv.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab1HXKCL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 06:02:11 -0400
Subject: Does brcmsmac supports monitor mode ?
From: jarek <jarek@poczta.srv.pl>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 11:19:24 +0200
Message-ID: <1314177564.6061.13.camel@jlap2.macro.local> (sfid-20110824_120214_555816_EA84A73D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

The following sequence stucks computer:

iwconfig wlan0 mode monitor
ifconfig wlan0 up

Tested on HP Mini 5103 with Debian, kernel 2.6.32-5-686 and
compat-wireless-2011-08-23.

There is also some issue with building driver. The file 
net/mac80211/main.c and some others wants to include pm_qos.h which does
not exists. 
I've symlinked pm_qos_params.h to pm_qos.h to fix the problem.

best regards
Jarek

