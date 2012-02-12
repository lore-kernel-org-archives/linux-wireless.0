Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44218 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2BLSDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 13:03:12 -0500
Received: by iacb35 with SMTP id b35so3025845iac.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 10:03:12 -0800 (PST)
Message-ID: <4F37FEDC.60607@lwfinger.net> (sfid-20120212_190316_073587_B89CE8D7)
Date: Sun, 12 Feb 2012 12:03:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: From: Build regressions/improvements in v3.3-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fellow wireless developers:

In http://lkml.indiana.edu/hypermail/linux/kernel/1202.1/01964.html, Geert 
Uytterhoeven lists the following warnings as occurring in mainline V3.3-rc3. The 
list is considerably smaller than were found for V3.2. In addition, there are no 
longer any build errors for wireless.

I'm pretty sure the remaining warnings are not present in the current 
wireless-testing code using "gcc (SUSE Linux) 4.6.2", but I'm posting them so 
that you know some compiler/architecture combination reports a problem. The 
warnings are as follows:

+ src/drivers/net/wireless/ath/ath5k/base.c: warning: return from incompatible 
pointer type: => 84, 85:1
+ src/drivers/net/wireless/ath/ath6kl/init.c: warning: 'hw' may be used 
uninitialized in this function: => 1377:26
+ src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'in' is used 
uninitialized in this function: => 915
+ src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'in' may be 
used uninitialized in this function: => 915
+ src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'val' is used 
uninitialized in this function: => 765, 1159
+ src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'val' may be 
used uninitialized in this function: => 765, 1159
+ src/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c: warning: 'w' is used 
uninitialized in this function: => 1185
+ src/drivers/net/wireless/brcm80211/brcmsmac/main.c: warning: comparison is 
always false due to limited range of data type: => 5682, 5582
+ src/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c: warning: 'byte_val' is 
used uninitialized in this function: => 280
+ src/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c: warning: 'reg_val' is 
used uninitialized in this function: => 487
+ src/drivers/net/wireless/ipw2x00/libipw_wx.c: warning: unused variable 'dev': 
=> 526
+ src/drivers/net/wireless/orinoco/orinoco_usb.c: warning: 'version' defined but 
not used: => 1759, 1759:13

Larry
