Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:39817 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752148AbdLVAM2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 19:12:28 -0500
Received: by mail-qk0-f170.google.com with SMTP id u184so33003794qkd.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 16:12:28 -0800 (PST)
Received: from ?IPv6:2804:7f1:2280:b90b:d178:8601:6582:fd3c? ([2804:7f1:2280:b90b:d178:8601:6582:fd3c])
        by smtp.gmail.com with ESMTPSA id p191sm4462560qke.43.2017.12.21.16.12.25
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Dec 2017 16:12:26 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: =?UTF-8?Q?Fl=c3=a1vio_Silveira?= <flavioguiraldo@gmail.com>
Subject: ath9k dropping connections
Message-ID: <f5b539a5-5365-7a1d-101d-591b5face78a@gmail.com> (sfid-20171222_011233_205072_B5F0EF0D)
Date: Thu, 21 Dec 2017 22:12:18 -0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good evening,

   I have a wireless router running LEDE Reboot (SNAPSHOT, 
r5445-04127f0fec), with kernel 4.9.65 and I'm seeing connections being 
dropped without any error in dmesg. To fix I have to restart wifi by 
issuing "wifi down; wifi up"

   It was previously running OpenWrt Barrier Breaker and was presenting 
the same issue, except it would give me an error similar to this one: 
"ath: phy0: Failed to stop TX DMA, queues=0x005!"

   After doing some research it seems this error is related to 
environment interference and it was fixed in later kernel versions, the 
reason I gave LEDE a try. It makes sense, because this router worked 
wonderfully for at least a year before giving this issue.

   The reason I am sending this e-mail is to receive suggestions on how 
can I debug it properly, because, as pointed above, dmesg shows no errors.

Regards,
   Flavio Silveira
