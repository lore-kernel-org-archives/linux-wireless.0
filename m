Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48324 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab1CERLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 12:11:20 -0500
MIME-Version: 1.0
Date: Sat, 5 Mar 2011 18:11:20 +0100
Message-ID: <AANLkTinhThfS587rkX4y1UbJLQzQKEWGfrFArUVGD3Ew@mail.gmail.com>
Subject: brcm80211: the system freezes if booted with laptop wifi switch to OFF
From: Francis Moreau <francis.moro@gmail.com>
To: brudley@broadcom.com
Cc: gregkh@suse.de, linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently running 2.6.38-rc6, and if I boot with my WIFI switch
set to off position, the system freezes entirely when bringing up the
wlan0 interface.

There's no trace so I don't really know how I can help to debug this further.

Thanks
-- 
Francis
