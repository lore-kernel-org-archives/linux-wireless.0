Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45794 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135Ab3FGPOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 11:14:33 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so4769968pbb.22
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jun 2013 08:14:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 11:14:32 -0400
Message-ID: <CA+7oygfDcFYaE+=n_5Vygk5SuwwMCtF2SCeeeW-c3dx16E1Uyw@mail.gmail.com> (sfid-20130607_171436_628019_AC9FBAA8)
Subject: trying to build backports, "input in flex scanner failed"
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to build backports-3.10-rc1-2 on an Ubuntu 12.04 LTS.
Whenever I try to start a clean build, I get the error:

gnychis@parallels:/media/psf/Documents/thesis/backports-3.10-rc1-2$
make defconfig-rt2x00
cc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
-fomit-frame-pointer   -c -o conf.o conf.c
cc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
-fomit-frame-pointer   -c -o zconf.tab.o zconf.tab.c
cc   conf.o zconf.tab.o   -o conf
input in flex scanner failed
make[1]: *** [defconfig-rt2x00] Error 2
make: *** [defconfig-rt2x00] Error 2

I have flex installed.  It's not getting very far.  Does anyone know
what the issue could be here?

Thanks!
