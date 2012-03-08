Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52906 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab2CHQCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 11:02:24 -0500
Received: by bkcik5 with SMTP id ik5so468360bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 08:02:23 -0800 (PST)
Message-ID: <4F58D80D.8070905@gmail.com> (sfid-20120308_170232_038000_E1AAC03E)
Date: Thu, 08 Mar 2012 17:02:21 +0100
From: Aaron <regtothismail@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Building and Installation errors due to modprobe -l was deprecated
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have problems with building and installing compat-wireless-3.3-rc1-2 
drivers due to modprobe -l option is obsolete.
Debian wheezy/sid
Linux laptop 3.2.0-2-amd64 #1 SMP Sun Mar 4 22:48:17 UTC 2012 x86_64 
GNU/Linux

# make install
/sbin/modprobe: invalid option -- 'l'
/sbin/modprobe: invalid option -- 'l'

Your old wireless subsystem modules were left intact:

/sbin/modprobe: invalid option -- 'l'
make: *** [uninstall] Error 1

Best regards,
Aaron
