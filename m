Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:36584 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751123AbdKSPQD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Nov 2017 10:16:03 -0500
Received: by mail-qk0-f178.google.com with SMTP id o6so4706688qkh.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Nov 2017 07:16:03 -0800 (PST)
Cc: linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        nishants@marvell.com, gbhat@marvell.com, huxm@marvell.com
From: Ellie Reeves <ellierevves@gmail.com>
Subject: Marvell Mwifiex wireless driver: mwifiex_pcie broken on Marvell
 ESPRESSOBin
Message-ID: <6dc0221c-c7ec-d107-02e8-0ab443807e51@gmail.com> (sfid-20171119_161612_705743_9693C2D4)
Date: Sun, 19 Nov 2017 10:15:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I noticed the Marvell Mwifiex wireless driver ended up broken since 
kernel 4.13.0, and it is still the case with 4.14.0 on the Marvell 
ESPRESSOBin, soled by Globalscale Technology. I bought the official 
wireless card from them at the same time as the board. However since 
kernel 4.13.0, wifi as provided via mwifiex_pcie module stopped working. 
I don't have much info on the userspace side, as all that happens is the 
wireless interface is never brought up and stays in 'NO-CARRIER'  state 
according to 'ip a'. However on kernel side, I hope I have some info 
that are more useful ! :) This was logged via systemd-journald with 
debug turned on in mwifiex driver. I am willing to try anything to get 
this kernel working, as it's a lts kernel contrary to 4.12.12 on which 
I'm forced to run for now.

https://gist.githubusercontent.com/mk-fg/27c2505fd3bffcf0af87777aaafb71fe/raw/fda70ff9f8eaab248a104e03922323cf2f4754bf/tmp.txt

I hope these info will be useful in debugging. I'm new to all these 
kernel stuff, so I may have posted to the wrong place or in a wrong way, 
if so, please let me know.

Thanks in advance

-- 
Ellie Reeves
