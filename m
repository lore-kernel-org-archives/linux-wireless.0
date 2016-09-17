Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35037 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752569AbcIQPwg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:52:36 -0400
Received: by mail-oi0-f51.google.com with SMTP id w11so144531397oia.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2016 08:52:35 -0700 (PDT)
MIME-Version: 1.0
From: bruce m beach <brucembeach@gmail.com>
Date: Sat, 17 Sep 2016 08:52:34 -0700
Message-ID: <CAArymCkTyLUsxMsDJXVM=XvmFZAK-uWLLuP3gXSY9_hqcjWHjg@mail.gmail.com> (sfid-20160917_175239_781582_90371CB4)
Subject: ath9k_htc kernel driver regression affecting throughput
To: linux-wireless@vger.kernel.org
Cc: linux@rempel-privat.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Hm.. found here one report about bad perfomance on this driver
>> https://ubuntuforums.org/showthread.php?t=2312343
>>
>> affected persons seems to use WEP encryption.
>>
>> What encryption do are you using?

I just wish I could do some testing on a single machine. Every test
suite I've seen always involves 2 machines. Why can't I use the wifi
chip on the mother board and the ar9271(a usb stick) to test basic
communications on the ar9271. The problem is I don't know where to begin.

Bruce
