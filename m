Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34841 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdC1RMJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 13:12:09 -0400
Received: by mail-qk0-f182.google.com with SMTP id r142so42518132qke.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 10:12:08 -0700 (PDT)
MIME-Version: 1.0
From: Matthew Stanger <matthew_stanger@trimble.com>
Date: Tue, 28 Mar 2017 11:11:51 -0600
Message-ID: <CANr77M0xc=zD17HK1Gu2GT7Y_P=QC65UrHkvwj+JntenHSHNSA@mail.gmail.com> (sfid-20170328_191225_988352_2A764C56)
Subject: Formatting of db.txt
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to set antenna gain in the db.txt following the
documentation from:
https://wireless.wiki.kernel.org/en/developers/regulatory/processing_rules

If I copy the example exactly show in the link:

country CR:
        (2402 - 2482 @ 40), (N/A, 20)
        (5170 - 5250 @ 20), (3, 17)
        (5250 - 5330 @ 20), (3, 23), DFS
        (5735 - 5835 @ 20), (3, 30)

and do a make I get a parsing error:
dbparse.SyntaxError: Syntax error in line 288 (invalid power data)
make: *** [regulatory.bin] Error 1

 I can change freq and power levels and other settings and everything
builds fine. What am I missing about setting antenna gain?

Thanks,
Matt
