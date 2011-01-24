Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49085 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1AXVr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 16:47:58 -0500
Received: by iyj18 with SMTP id 18so4426891iyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 13:47:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <op.vpte6up33ri7v4@arend-laptop>
References: <AANLkTikam0zcxe00UCT4BDQMmrJcPKf1Hbt6=PBokpga@mail.gmail.com>
 <4D3B0390.5070108@broadcom.com> <AANLkTinwPrar6ZBhSALBif8__4mHHsKuDYKsgr4FDqtu@mail.gmail.com>
 <op.vptd4dqs3ri7v4@arend-laptop> <AANLkTimk3qY87mP5oROnsVOGaPDV2-UAm7UrXST+1mms@mail.gmail.com>
 <op.vpte6up33ri7v4@arend-laptop>
From: Jamie Kitson <jamie@kitten-x.com>
Date: Mon, 24 Jan 2011 21:47:37 +0000
Message-ID: <AANLkTikB9=xKS0jX7Rz9qLOctaY+Rxv-9HH3p=Ydza85@mail.gmail.com>
Subject: Re: Kernel Panic wlc_mac80211.c Line 6093
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> too quote a gremlin: feed me (with any debug experiences you may have).

Well for some reason when I got home today my machine crashed every
time it was bringing the wireless interface up until I disabled the
brcm80211 module, even without the noapic option. The crash looks a
little different:

http://farm6.static.flickr.com/5216/5385766744_632eb67670_b.jpg

Did you notice that someone on that Arch thread suggested that it
might be solved by using n mode only on the wireless router?

https://bbs.archlinux.org/viewtopic.php?pid=882237#p882237

Jamie
