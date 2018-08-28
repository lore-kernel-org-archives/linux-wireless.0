Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:38159 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH1OXh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 10:23:37 -0400
Received: by mail-qt0-f174.google.com with SMTP id x7-v6so1039252qtk.5
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 03:32:37 -0700 (PDT)
MIME-Version: 1.0
From: Jukka Pirinen <jukka.pirinen@gmail.com>
Date: Tue, 28 Aug 2018 13:32:25 +0300
Message-ID: <CADyz9cHb+T3dTfQGShs3oHiZagQDdJP8LRKwmWPzp1fD_EPxag@mail.gmail.com> (sfid-20180828_123240_499444_11E3B386)
Subject: wireless-regdb: Update regulatory rules for Finland (FI) on 5GHz (SRD devices)
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Viestint=C3=A4virasto 15 AM/2018 M

Section 10 Non-specific short range devices
https://www.finlex.fi/data/normit/32670/Regulation_15AM.pdf


diff --git a/db.txt b/db.txt
index 8cf7dee..7abb064 100644
--- a/db.txt
+++ b/db.txt
@@ -460,6 +460,8 @@ country FI: DFS-ETSI
        (5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=3DETSI
        (5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=3DETSI
        (5470 - 5725 @ 160), (27), DFS, wmmrule=3DETSI
+        # short range devices (ETSI EN 300 440-1)
+        (5725 - 5875 @ 80), (25 mW)
        # 60 GHz band channels 1-4, ref: Etsi En 302 567
        (57000 - 66000 @ 2160), (40)
