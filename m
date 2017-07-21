Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34526 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964950AbdGUBSU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 21:18:20 -0400
Received: by mail-oi0-f43.google.com with SMTP id q4so41085807oif.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jul 2017 18:18:20 -0700 (PDT)
To: Kalle Valo <kvalo@codeaurora.org>, Greg KH <gregkh@linux.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>, Pkshih <pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: New Realtek driver
Message-ID: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net> (sfid-20170721_031825_015971_02764A54)
Date: Thu, 20 Jul 2017 20:18:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle and Greg,

Once again I find myself in the awkward position of needing to submit code to 
two different trees, i.e. wireless and staging.

The code in question concerns a new Realtek device, the RTL8822BE. The device is 
already shipping, and Realtek would like it to be available in kernel 3.14. As 
it consists of ~120,000 new lines of code, I have assured Realtek that 3.14 
would not be possible, at least in the wireless tree. What I plan to do is 
submit the changes in the existing drivers through wireless, and the three 
totally new drivers through staging. My expectation is that this code would live 
for a relatively short time there, but going that route would give time for the 
code to be reviewed properly, but still be available in a kernel driver. All of 
the new code will be available in a GitHub repo maintained by Realtek for those 
users whose distros do not configure anything in staging.

For my part, I will push the wireless tree material as fast as I can and hope 
there is time available near the end of the 4.13-rcX sequence for the material 
to reach 4.14-rc1.

Thanks for your understanding and help.

Larry
