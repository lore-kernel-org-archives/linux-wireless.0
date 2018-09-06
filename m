Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fairtragen.de ([5.45.110.153]:57030 "EHLO mx.fairtragen.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbeIFNfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:35:53 -0400
Received: from ip-109-41-65-60.web.vodafone.de ([109.41.65.60] helo=[192.168.0.151])
        by mx.fairtragen.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <leon@fairtragen.de>)
        id 1fxppr-0001ir-Gu
        for linux-wireless@vger.kernel.org; Thu, 06 Sep 2018 10:40:33 +0200
To: linux-wireless@vger.kernel.org
From: Leon Fellows <leon@fairtragen.de>
Subject: ath10k_pci firmware crashes after shutdown of networking
Message-ID: <55244c54-e475-81ab-7867-b4a38d7102f0@fairtragen.de> (sfid-20180906_110130_194111_F80C89AE)
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
