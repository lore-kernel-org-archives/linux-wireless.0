Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.191]:38772 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYG1KvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 06:51:07 -0400
Received: by mu-out-0910.google.com with SMTP id w8so5165919mue.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 03:51:04 -0700 (PDT)
Message-ID: <5f68ea7b0807280351u4f6b6a59v8304a7a3b53436be@mail.gmail.com> (sfid-20080728_125111_102377_B11BE270)
Date: Mon, 28 Jul 2008 12:51:04 +0200
From: "Angel Mieres" <mieres.angel@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: IWL5000
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Im trying to get working intel wifi link 5100 on ubuntu 8.0.4, but i
have some problems; the procedure that i follow was:
    1.- I try to get working with ndiswrapper, i get the lastest
drivers availables for windowz, load the inf file,
     check that device was recognize by ndiswrapper(installed & device
present), but when i load the ndiswrapper module, it appears:
     "unknown symbol: ntoskrnl.exe:'KeBugCheck'; couldn't prepare
driver 'netw5x32'"
      So, i decide to take a look of compat-wireless project that
support this driver(right?).
    2.- I get the firmware of iwl5000, copy the firmware on
/lib/firmware, i get the latest compat-wireless-2.6 tar file, after
this,
       I compile the drivers(make && make install), i try load the
driver; at dmesg it appears that ipw4965 loads perfectly but the led
of the wifi, it doesn't work and
       no one devices appear to be installed.

So, someone have this NIC working? Please help me a bit. All
suggestions are welcome.
Thanks guys
