Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:43468 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETVVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 17:21:49 -0400
Received: by mail-qg0-f52.google.com with SMTP id a108so1794517qge.11
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 14:21:48 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 20 May 2014 15:21:48 -0600
Message-ID: <CAMNaBtPyqgkZ5T_Kegz3YGP3RTv7xzpWFnRt2CRxCxrSAn_Taw@mail.gmail.com> (sfid-20140520_232201_023340_2F2130B3)
Subject: Questions about VIRTUAL NETWORK INTERFACE
From: Junguk Cho <jmanbal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I tried to use VIRTUAL NETWORK INTERFACE with 802.11 network.
Based on this web
page(http://wireless.kernel.org/en/users/Documentation/iw/vif/), we
can use mac80211 Multiple Virtual Interface(vif) with one physical
wireless network card.

I used N150UA usb wireless network card and recent version of linux
kernel(3.14). I can create virtual interfaces(vifs) with iw command
line tools. However, only one vif can associated with AP.

I think it is limited by my wireless network card.

So, does anyone succeed associating multiple APs with VIF by using iw command?
If so, please let me know which wireless network card used.

Also, are there list of devices which supports those functionality.


Thanks,
