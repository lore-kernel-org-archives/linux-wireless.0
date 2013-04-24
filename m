Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f194.google.com ([209.85.217.194]:43742 "EHLO
	mail-lb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3DXOQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Apr 2013 10:16:19 -0400
Received: by mail-lb0-f194.google.com with SMTP id v10so510293lbd.5
        for <linux-wireless@vger.kernel.org>; Wed, 24 Apr 2013 07:16:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com>
References: <CALvqYaTZrtSsP9GQzH4B988KjPg+LRCcyREKZ1zkjoaEDKPHNA@mail.gmail.com>
Date: Wed, 24 Apr 2013 16:16:18 +0200
Message-ID: <CALvqYaTSYR43rS-pptFKCfsgvsatrUSz4v+AFBPQ0UrHC4WkXA@mail.gmail.com> (sfid-20130424_161633_669339_97B9CD67)
Subject: Fwd: Realtek 8192CU not working
From: Michael Stahn <michael.stahn.42@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I just checked out the 3.7.10-Kernel driver for the wireless Adapter
EW 7811Un 802.11n, ID 7392:7811 and it doesn't work: The driver gets
loaded but some IRQ-errors show up. Using the original driver doesn't
work either 1) driver needs patching for new kernel-API 2) Patched
Driver gets loaded but USB directly suspends and the device seems to
shut down permanently (ifconfig wlan0 up leads to error). I can't
paste any traces now but perhaps these problems can be confirmed after
all.
