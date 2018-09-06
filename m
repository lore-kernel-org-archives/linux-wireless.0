Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fairtragen.de ([5.45.110.153]:57031 "EHLO mx.fairtragen.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbeIFNfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:35:55 -0400
Received: from ip-109-41-65-60.web.vodafone.de ([109.41.65.60] helo=[192.168.0.151])
        by mx.fairtragen.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <leon@fairtragen.de>)
        id 1fxppr-0001is-IB
        for linux-wireless@vger.kernel.org; Thu, 06 Sep 2018 10:40:25 +0200
To: linux-wireless@vger.kernel.org
From: Leon Fellows <leon@fairtragen.de>
Subject: ath10k_pci firmware crashes after shutdown of networking
Message-ID: <88ebda03-cc09-ff52-77fc-ca3bc91697a3@fairtragen.de> (sfid-20180906_110130_787986_74A5DE9E)
Date: Thu, 6 Sep 2018 10:40:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I get a firmware crash, when I set my Laptop to "Standby".

I created a bug-report to NetworkManager:
https://bugzilla.gnome.org/show_bug.cgi?id=797067

But Thomas Haller reckons, the bug lies in the driver/firmware.

Can anyone give me some advice, what to do next?

Kind Regards,
Leon
