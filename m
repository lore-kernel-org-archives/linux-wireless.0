Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34932 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761561AbcISOBC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 10:01:02 -0400
Received: by mail-wm0-f66.google.com with SMTP id 133so15181191wmq.2
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2016 07:01:01 -0700 (PDT)
Received: from [192.168.0.15] (ip5f5beb74.dynamic.kabel-deutschland.de. [95.91.235.116])
        by smtp.gmail.com with ESMTPSA id p71sm22287949wmf.9.2016.09.19.07.00.59
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Sep 2016 07:00:59 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Volker Mische <volker.mische@gmail.com>
Subject: Problem with 40Mhz on 2.5GHz with Intel 8260
Message-ID: <24d0d9c5-7695-9364-c5fa-97e9d52712dc@gmail.com> (sfid-20160919_160106_911094_1F64C431)
Date: Mon, 19 Sep 2016 16:00:55 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having connectivity issues with an Intel 8260 on a 2.5GHz network
when using 40Mhz. I'm getting errors like

    Queue 2 stuck for 10000 ms.

I've upgrade my system to the firmware version 21 (21.373438.0) and
Kernel 4.8.0-rc6 in hope that it fixes the issue and to be able to debug
the problem.

I then found the page about platform noise [1]. I don't have any issue
for several hours now (normally I was hitting the issue every few
minutes) as I've set the cfg80211_disable_40mhz_24ghz parameter.

Now I wonder, is it worth debugging the issue with being on 40MHz or is
disabling the proper solution and I should bother.

[1]:
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#about_platform_noise

Cheers,
  Volker
