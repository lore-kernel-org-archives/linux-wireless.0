Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43180 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1DOJ4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:56:19 -0400
Received: by fxm17 with SMTP id 17so1709406fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 02:56:18 -0700 (PDT)
Message-ID: <4DA8163F.6040308@gmail.com>
Date: Fri, 15 Apr 2011 12:56:15 +0300
From: Alex <alfragk@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: crda fails to compile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the last couple of days i've beeen trying to compile crda on my linux 
box (gentoo) without success.

I've downloaded crda-1.1.1, and i've installed all the requirements as 
described in the README file.

However, when i run make i get the following error:

GEN  keys-gcrypt.c
   Trusted pubkeys: pubkeys/linville.key.pub.pem
   File "./utils/key2pub.py", line 6
     except ImportError, e:
                       ^
SyntaxError: invalid syntax
make: *** [keys-gcrypt.c] Error 1


Any help would be appreciated,

Alex
