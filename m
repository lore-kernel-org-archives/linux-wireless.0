Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56771 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaHJQz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 12:55:57 -0400
Received: by mail-ob0-f171.google.com with SMTP id wm4so5421332obc.16
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 09:55:56 -0700 (PDT)
MIME-Version: 1.0
From: Jon Nelson <jnelson@jamponi.net>
Date: Sun, 10 Aug 2014 11:55:36 -0500
Message-ID: <CAKuK5J2=JLZ3XaZguaD+=mparR4BWXmnNZhU0nryOPvtFz8aOA@mail.gmail.com> (sfid-20140810_185601_696434_54CFCC38)
Subject: brcmsmac power consumption issues
To: Linux Kernel <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As reported on the Novell and Kernel bugzillas:
11
https://bugzilla.novell.com/show_bug.cgi?id=890454
and
https://bugzilla.kernel.org/show_bug.cgi?id=81721

Short version: I have a laptop (Lenovo B570) with a built-in Broadcom
wireless chipset. Using the 'brcmsmac' driver, I observed very high
power consumption:

4000-6000mW as compared to 100-200mW for several other drivers.

Trying (openSUSE) kernel 3.16.0-rc7-2-desktop with backports-20140725,
that appears to have been reduced to 350-3900mW. A nice change but
still much higher than the rtl8192cu that I tested with the same
kernel and backports (3-30x higher).




-- 
Jon
Software Blacksmith
