Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f181.google.com ([209.85.210.181]:61235 "EHLO
	mail-yx0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZIBOWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 10:22:55 -0400
Received: by yxe11 with SMTP id 11so2806885yxe.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 07:22:57 -0700 (PDT)
Message-ID: <4A9E7FBE.6060705@gmail.com>
Date: Wed, 02 Sep 2009 10:22:54 -0400
From: Jeremy Wolcott <jeremy.wolcott@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless and DKMS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Has anybody tried to get compat-wireless working with DKMS?  This would 
be really handy for me since I run Ubuntu and they have been pushing 
kernel updates pretty frequently lately, but I need the newest 
compat-wireless to run my Atheros card in master mode via ath5k...

I tried for quite a while today and the build just won't work.  (The 
'make clean' step returns error 2, and then the build itself fails with 
"(directory it's building in) is a directory.  Stop.")  I think it's 
because the Makefile for compat-wireless uses the PWD environment 
variable, but I'm not well-versed enough in Makefiles to fix it up so 
that it'll work from a different directory (DKMS builds modules in 
/var/lib/dkms/MODULE_NAME/VERSION/build instead of wherever I unpacked 
the source).

Any advice would be appreciated...

Thanks,

-Jeremy
