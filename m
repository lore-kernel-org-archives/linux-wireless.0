Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36347 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbbCZQM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 12:12:29 -0400
Received: by qgf60 with SMTP id 60so87176462qgf.3
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 09:12:29 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 26 Mar 2015 18:12:28 +0200
Message-ID: <CABU1Ay8sVdLuHURHhmhsOf_aCVgvYnR_fw6_HyqLXziGmp3_fA@mail.gmail.com> (sfid-20150326_171232_750954_645BCF26)
Subject: mediatek mt7630e and ksoftirqd CPU load
From: George Moutsopoulos <gmoutso@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear developers,

if this is not the right place to post this, sorry for the spam. I
haven't filed a bug report yet. Tell me if I should. I am not sure if
the problem is something kernel developers can solve.

On a laptop ASUS TP500LN, I have a wireless pcie card mt7630e from
mediatek. It is a wifi/bluetooth combo.

The driver is not in the kernel, but mediatek provides it for linux
from the download site
http://www.mediatek.com/en/downloads/

The driver does not support kernel 3.16 and above. I followed the
instructions at
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1220146

The module compiles and loads succesfully. I followed the post by
tobias bora from the ubuntu bug. It compiles on kernel version 3.16
and above (tried up to 3.19).

Like the rest on the ubuntu bug list, the wifi works and I connect
succesfully, but ksoftirqd gets 100% cpu on one of the cores.

Shall I open a bug report? I have contacted mediatek twice but they
haven't replied. I hope it is something you can look at.

Many regards,
George
