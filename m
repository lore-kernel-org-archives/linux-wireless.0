Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45460 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3EHMUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 08:20:32 -0400
Received: by mail-pa0-f51.google.com with SMTP id ld10so1285653pab.24
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 05:20:32 -0700 (PDT)
Received: from [192.168.2.168] (61-219-48-114.HINET-IP.hinet.net. [61.219.48.114])
        by mx.google.com with ESMTPSA id aj2sm32451617pbc.1.2013.05.08.05.20.30
        for <linux-wireless@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Wed, 08 May 2013 05:20:31 -0700 (PDT)
Subject: atheros AR5B22, using ath9k, can't switch between inscure and
 WEP/WPA
From: Wally <wally.yeh@a-trust.com.tw>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 May 2013 20:25:05 +0800
Message-ID: <1368015905.17674.11.camel@bigdick-desktop> (sfid-20130508_142037_619523_2FF1B4A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, guys:
    Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
and build it for armel on my arm board, it works great but with one
little problem:

If I connect to an inscure AP then change to a WEP/WPA AP, I can't
connect the inscure one again, I have to run "modprobe -r ath9k;
modprobe ath9k" to connect the inscure AP.

    I think this may be a bug in the ath9k driver, I also search this
bug on web but without an answer, so I send this letter for help.

    Any advice would be grateful, thanks.

Wally 


