Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46468 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1AYVzI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 16:55:08 -0500
Received: by bwz15 with SMTP id 15so609777bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:55:07 -0800 (PST)
From: Richard Riley <rileyrg@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: bcm4313/bcrm80211 and debian liquirix
Date: Tue, 25 Jan 2011 22:48:25 +0100
Message-ID: <vnbp34slhy.fsf@news.eternal-september.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


According to docs I googled up the brcm80211 driver should work with the
bcm4313 wireless device.

I have installed the debian firmware-brcm80211 package but when I
modprobe the bcrm80211 module there is kernel panic, I get the black
screen of death and a dump saying  (reading off the
laptop screen) 

!(sdu->cloned) failed : file wlc_mac80211.c line 5140


I'm fairly new to all this so any pointers greatfully received. My
kernel is:-

Linux asus1015pem 2.6.37-0.slh.7-aptosid-686 #1 SMP PREEMPT Sun Jan 16
23:16:55 UTC 2011 i686 GNU/Linux


If I can provide more info please let me know and let me know how.

regards

r.
