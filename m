Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:36413 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbbGBFoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 01:44:09 -0400
Received: by ykdr198 with SMTP id r198so59189112ykd.3
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2015 22:44:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 1 Jul 2015 22:44:09 -0700
Message-ID: <CAHr=Vq=hJr6WUQgFXftMSG2zYgwtCXgoTaXBzRfM8-kQa2-K2w@mail.gmail.com> (sfid-20150702_074415_160496_9A026030)
Subject: wireless-regdb: update CA rules for 5600 - 5650 mHz
From: Wei Zhong <wzhong@google.com>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 2fef4cad8a1bd9cbbf178e59a1b3ca672b057095
Author: Wei Zhong <wzhong@google.com>
Date:   Wed Jul 1 22:39:09 2015 -0700

    wireless-regdb: update CA rules for 5600 - 5650 mHz

    Related regulation:
    http://www.ic.gc.ca/eic/site/smt-gst.nsf/eng/sf10971.html#s6.2.3

    Frequency Bands 5470-5600 MHz and 5650-5725 MHz
    Until further notice, devices subject to this section [i.e. Wifi device
    supporting 5 GHz bands] shall not be capable of transmitting in the band
    5600-5650 MHz. This restriction is for the protection of Environment
    Canada’s weather radars operating in this band.

diff --git a/db.txt b/db.txt
index 809cd3c..da0cfad 100644
--- a/db.txt
+++ b/db.txt
@@ -216,7 +216,8 @@ country CA: DFS-FCC
        (2402 - 2472 @ 40), (30)
        (5170 - 5250 @ 80), (17), AUTO-BW
        (5250 - 5330 @ 80), (24), DFS, AUTO-BW
-       (5490 - 5730 @ 160), (24), DFS
+       (5490 - 5600 @ 80), (24), DFS
+       (5650 - 5730 @ 40), (24), DFS
        (5735 - 5835 @ 80), (30)

 # Source:
