Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43691 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2BJVqf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 16:46:35 -0500
Received: by wgbdt10 with SMTP id dt10so3184542wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2012 13:46:34 -0800 (PST)
MIME-Version: 1.0
From: Claudio Rossi <rossi.claudio.82@gmail.com>
Date: Fri, 10 Feb 2012 22:46:14 +0100
Message-ID: <CAO1ZyK=NRx2WD_B6=zikpTvX+Z+2F3t_sVU2Hrc3DeaZPMUwNw@mail.gmail.com> (sfid-20120210_224638_583187_5F92641B)
Subject: How to debug the linux wireless driver
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
  I have started to modify the linux wireless (mac80211) in order to
had some MAC layer statistics. I am using compat-wireless-3.2-rc6-3
and this is my first kernel programming experience. I do not know how
to face programming errors without corrupting a kernel version, e.g.,
due to my modification to the code, in this moment I get a black
screen with  kernel 2.6.32-37-generic. I have now booted with
2.6.32-38-generic: how  can I restore the previous version of the
modules in the kernel 2.6.37-generic?

Moreover, is there any way to do a sort of debug ?

Thank you

-- 
Claudio Rossi
-------------------
Office @ PoliTO: +39 011 5644194
