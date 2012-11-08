Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nk11p00mm-asmtp003.mac.com ([17.158.161.2]:51912 "EHLO
	nk11p00mm-asmtp003.mac.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab2KHI4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2012 03:56:54 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Received: from [10.20.200.168]
 (p3027-ipbf5206marunouchi.tokyo.ocn.ne.jp [118.8.142.27])
 by nk11p00mm-asmtp003.mac.com
 (Oracle Communications Messaging Server 7u4-26.01(7.0.4.26.0) 64bit (built Jul
 13 2012)) with ESMTPSA id <0MD500KJ0VIQ0840@nk11p00mm-asmtp003.mac.com> for
 linux-wireless@vger.kernel.org; Thu, 08 Nov 2012 08:56:53 +0000 (GMT)
Message-id: <509B73D5.5000206@mac.com> (sfid-20121108_095707_853850_16E0E07A)
Date: Thu, 08 Nov 2012 17:56:53 +0900
From: Akira Nonaka <nonaka@mac.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: "mac80211.ko" and "cfg80211.ko" compatibility issue.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have a problem with the compat-wireless. It seems "mac80211.ko" and
"cfg80211.ko" are not compatible with the ones in main line kernel. In
my case, it is kernel 3.4.9(Fedora 16).

I want to use  compat-wireless version of "mac80211.ko" and
"cfg80211.ko" for Realtek rtl8723ae but for other wireless cards, I want
to use main line kernel version of "mac80211.ko" and "cfg80211.ko".

This switch should happen at the boot time since I need to support a lot
of PCs with the single kernel.

Can someone tell me where the "modprobe rtl8723ae (and for other PCI
devices)" get called when I run the kernel on the PC with rtl8723
wireless card? I searched the entire scripts under /etc but I could not
find.

What is the right thing to do? I appreciate your advise.

-- 
Akira Nonaka
