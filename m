Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s10.blu0.hotmail.com ([65.55.111.85]:17968 "EHLO
	blu0-omc2-s10.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757401Ab1F0JYU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 05:24:20 -0400
Message-ID: <blu158-w716EEAA2F0043B4BEAFB387570@phx.gbl> (sfid-20110627_113635_134075_7BF9BC2C)
From: Fred Matthews <fredmm@hotmail.co.uk>
To: <linux-wireless@vger.kernel.org>
Subject: Re: Compat-wireless release for 2011-06-26 is baked
Date: Mon, 27 Jun 2011 10:24:19 +0100
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi all,
I have had compiler errors when making compat-2011-06-23 - compat-2011-06-26. 
  CC [M]  /home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.o/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c: In function ‘nl80211_send_bss’:/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:3641: error: implicit declaration of function ‘genl_dump_check_consistent’/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c: In function ‘nl80211_dump_scan’:/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.c:3731: error: ‘struct netlink_callback’ has no member named ‘seq’make[3]: *** [/home/wimo/new/compat-wireless-2011-06-26/net/wireless/nl80211.o] Error 1make[2]: *** [/home/wimo/new/compat-wireless-2011-06-26/net/wireless] Error 2make[1]: *** [_module_/home/wimo/new/compat-wireless-2011-06-26] Error 2make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-25-generic'make: *** [modules] Error 2
There appears to be a problem with nl80211.c as you see in the error messages. However when I copied compat-2011-06-22 version's nl80211.c and nl80211.h to compat-2011-06-26 (replacing its original), it compiled and worked just fine.
Thanks!
On Sun, Jun 26, 2011 at 8:02 PM, Compat-wireless cronjob account <compat@orbit-lab.org> wrote:>> compat-wireless code metrics>>    823408 - Total upstream lines of code being pulled>      2385 - backport code changes>      2078 - backport code additions>       307 - backport code deletions>      8123 - backport from compat module>     10508 - total backport code>    1.2762 - % of code consists of backport work> --> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html>
 		 	   		  