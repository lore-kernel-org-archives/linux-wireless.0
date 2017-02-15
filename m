Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:35049 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751544AbdBOJya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:54:30 -0500
Received: by mail-vk0-f66.google.com with SMTP id 23so12277254vkc.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2017 01:54:29 -0800 (PST)
MIME-Version: 1.0
From: ravin goyal <ravirocks1021@gmail.com>
Date: Wed, 15 Feb 2017 15:24:08 +0530
Message-ID: <CANU0Mn00ju_SZ3L+ipdnZ5R-Y1m+T=MhjHmBjMpKN_i8NPWsrg@mail.gmail.com> (sfid-20170215_105648_646041_B1051776)
Subject: wireless driver crashing frequently
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I have a banana pi m2+ running raspbian lite 3.4.112-sun8i
I am running hostapd on it

My wireless chip is AP6212 ,when I start hostapd sometime it runs
sometime it leads to kernel crash

please follow this link to see the kernel messages: https://clbin.com/PXBSB?hl

I have been told to ask my doubt here since it is the problem of the
driver in the kernel

To make hostapd work properly I have to manuallly run this command

modprobe -v bcmdhd op_mode=2

bcmdhd is my wireless driver

after this hostapd is able to broadcast the ssid, if i don't provide
the op_mode=2 while loading the module, hostapd will not broadcast the
ssid.

any help on this ?


Regards
Ravin
