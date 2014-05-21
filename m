Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:53959 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaEUBWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 21:22:46 -0400
Received: by mail-vc0-f177.google.com with SMTP id if17so1630787vcb.22
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 18:22:45 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 21 May 2014 09:22:45 +0800
Message-ID: <CAEFj984H4HvwgdLyWo3=7xcFysgz=cbepdp7tUPpGztpzO-dOw@mail.gmail.com> (sfid-20140521_032249_794941_AB9ACBD9)
Subject: Re: 802.11s mode without HWMP
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	hrogge@gmail.com, Thomas Pedersen <thomas@noack.us>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I will have a look at both tables and see what I can do with them,
> maybe a second netlink command is necessary in cfg80211.

You can probably take a look on patches by Shinoda submitted to o11s
mailing list:
http://lists.open80211s.org/pipermail/devel/2012-September/002112.html

It extends the support of mpath dump to show the MAC address behind
the proxy mesh gate.

In additional to this, as mentioned in IEEE 802.11-2012 section
13.11.4.3, the proxy mesh gate can generate a PXU element to others to
inform external stations proxied by the proxy mesh gate. But o11s has
not implemented yet.

----
Chun-Yeow
