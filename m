Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36460 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdGFCvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 22:51:19 -0400
Received: by mail-oi0-f42.google.com with SMTP id x187so5846643oig.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jul 2017 19:51:18 -0700 (PDT)
Received: from linux-4v1g.suse (cpe-24-31-249-175.kc.res.rr.com. [24.31.249.175])
        by smtp.gmail.com with ESMTPSA id 187sm1548039oie.15.2017.07.05.19.51.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jul 2017 19:51:16 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Command equivalent in iw
Message-ID: <a496cdaa-41f3-53e1-bb4f-2843d5bd8b12@lwfinger.net> (sfid-20170706_045126_613081_B5FA97F7)
Date: Wed, 5 Jul 2017 21:51:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Someone using the rtlwifi code that is posted at GitHub wants to know the iw 
equivalent of "iwpriv wlan0 bandcfg" to limit the wireless interface to 802.11b, 
802.11g, or 802.11n. I only use simple iw commands, and I could not answer the 
question.

Thanks,

Larry
