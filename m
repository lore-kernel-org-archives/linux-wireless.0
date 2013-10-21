Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59025 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3JUSbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 14:31:21 -0400
Received: by mail-oa0-f44.google.com with SMTP id l20so5551830oag.17
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 11:31:20 -0700 (PDT)
Message-ID: <526572F6.7010807@lwfinger.net> (sfid-20131021_203124_360766_E81CCB79)
Date: Mon, 21 Oct 2013 13:31:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrewl733@aol.com, linux-wireless@vger.kernel.org
Subject: Re: Updates to 3.8 kernel break b43 Wireless with 4331 chipset
References: <8D09C98149E95D8-27D8-2CD34@Webmail-d105.sysops.aol.com>
In-Reply-To: <8D09C98149E95D8-27D8-2CD34@Webmail-d105.sysops.aol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It may just be me, but I kept getting a "deja vu" feeling when I read your 
report. Please minimize the repetition of material.

Unfortunately, I do not have a 4331 device, and I cannot duplicate your result. 
Ideally, the best approach would be for you to clone the Linux mainline git repo 
and verify that the latest 3.12-rc6 has the problem. If so, then you could 
bisect between that version and 3.8 to determine the commit that caused the 
failures. As I have no idea of your facility with kernel builds, that may be 
beyond your ability.

If you can locate an on-line list of the kernel changes between 3.8.13-1 and 
3.8.13.4-1 and post a URL, it might be possible for us to spot the faulty 
change. I do not even know how to interpret those versions. To me, it seems that 
both are based on 3.8.13. As 3.8 is EOL and not being updated by any of the 
kernel developers, all changes are now being done by Mageia. Thus, only they 
know what was done.

Larry

