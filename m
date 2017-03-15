Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38375 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdCOBOn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 21:14:43 -0400
Received: by mail-wm0-f48.google.com with SMTP id t189so11807936wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Mar 2017 18:14:41 -0700 (PDT)
Received: from localhost (81.201.218.87.dynamic.jazztel.es. [87.218.201.81])
        by smtp.gmail.com with ESMTPSA id q4sm1790721wme.17.2017.03.14.18.14.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Mar 2017 18:14:40 -0700 (PDT)
To: linux-wireless <linux-wireless@vger.kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [BUG] with a 4.10.x kernel it's impossible to apply country
 regulatory rules
Reply-To: linux-wireless <linux-wireless@vger.kernel.org>,
          Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <09a819fc-c936-6838-654b-e349c58a09ec@gmail.com> (sfid-20170315_021446_689528_C4513CA0)
Date: Wed, 15 Mar 2017 02:14:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Can anyone with a 4.10.x kernel run "iw reg get" to
verified it?

I get with different wireless devices and platforms:
global
country 00: DFS-UNSET
        (2402 - 2472 @ 40), (6, 20), (N/A)
        (2457 - 2482 @ 20), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (2474 - 2494 @ 20), (6, 20), (N/A), NO-OFDM, PASSIVE-SCAN
        (5170 - 5250 @ 80), (6, 20), (N/A), AUTO-BW, PASSIVE-SCAN
        (5250 - 5330 @ 80), (6, 20), (0 ms), DFS, AUTO-BW, PASSIVE-SCAN
        (5490 - 5730 @ 160), (6, 20), (0 ms), DFS, PASSIVE-SCAN
        (5735 - 5835 @ 80), (6, 20), (N/A), PASSIVE-SCAN
        (57240 - 63720 @ 2160), (N/A, 0), (N/A)


It works flawlessly with 4.9.13:
global
country ES: DFS-ETSI
        (2400 - 2483 @ 40), (N/A, 20), (N/A)
        (5150 - 5250 @ 80), (N/A, 23), (N/A), NO-OUTDOOR, AUTO-BW
        (5250 - 5350 @ 80), (N/A, 20), (0 ms), NO-OUTDOOR, DFS, AUTO-BW
        (5470 - 5725 @ 160), (N/A, 26), (0 ms), DFS
        (57000 - 66000 @ 2160), (N/A, 40), (N/A)

phy#0
country AW: DFS-ETSI
        (2402 - 2482 @ 40), (N/A, 20), (N/A)
        (5170 - 5250 @ 80), (N/A, 20), (N/A), AUTO-BW
        (5250 - 5330 @ 80), (N/A, 20), (0 ms), DFS, AUTO-BW
        (5490 - 5710 @ 160), (N/A, 27), (0 ms), DFS


Thank you.
