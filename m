Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1AGIGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 03:06:46 -0500
Received: by vws16 with SMTP id 16so7106554vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 00:06:45 -0800 (PST)
Received: by qwa26 with SMTP id 26so17549885qwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jan 2011 00:06:43 -0800 (PST)
MIME-Version: 1.0
From: Damian Minkov <damencho@sip-communicator.org>
Date: Fri, 7 Jan 2011 10:06:23 +0200
Message-ID: <AANLkTimekYjYh7uZ3enOQ+zX2_dpA25Zy0aATCDzw521@mail.gmail.com>
Subject: Question about ep-n8508
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently bought the device EDUP ep-n8508 but I have problems running
it under Ubuntu 10.10, kernel: 2.6.35-24-generic x86_64.
I tried with the drivers provided on the CD coming with the device
(rtl8192CU_linux_v2.0.939.20100726) have no problem compiling and
installing. But after loading the module no network device appears and
a lot of "usb write TimeOut!" in the messages.
Then I tried with latest driver edition from realtek website -
rtl8192CU_linux_v2.0.1212.20101208. Again with same result.
Here is all the output: http://pastebin.com/7xhkzYNC.
I saw there is a similar thread, with similar problems "Question about
Edimax 7811Un", but as I'm new to the list didn't manage to continue
that thread.

Seems a problem with amd64 systems. Is there any workaround? Anything
I can further test to help figuring this out?

Thanks in advance
damencho
