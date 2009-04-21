Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f118.google.com ([209.85.221.118]:39325 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZDUQFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 12:05:20 -0400
Received: by qyk16 with SMTP id 16so1218186qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 09:05:19 -0700 (PDT)
MIME-Version: 1.0
From: Joe McEachern <joe@qacafe.com>
Date: Tue, 21 Apr 2009 12:04:51 -0400
Message-ID: <204608400904210904r37f0a354n5fc6dddfa48da7ac@mail.gmail.com> (sfid-20090421_180524_426746_B857AD88)
Subject: cfg80211 ksize undefined building on 2.6.28-11
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Trying to build the latest compat-wireless-2009-04-20 on ubuntu Jaunty
produces an undefined symbol ksize.

$ more git-describe
v2.6.30-rc2-21670-gff8f5b2

Linux cdrouter 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17 01:58:03
UTC 2009 x86_64 GNU/Linux

  Building modules, stage 2.
  MODPOST 42 modules
WARNING: "ksize"
[/home/qacafe/driver_4_21/compat-wireless-2009-04-20/net/wireless/cfg80211.ko]
undefined!

I can upgrade to the 2.6.29 kernel to resolve this but I have other
issues with 2.6.29. Is there a work around for 2.6.28 kernels?

Thanks,

Joe
