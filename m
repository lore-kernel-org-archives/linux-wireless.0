Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59892 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab0AUTpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 14:45:46 -0500
Received: by ewy19 with SMTP id 19so408243ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 11:45:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <165941211001211143y45db17b7ob731a9d3a6e48957@mail.gmail.com>
References: <165941211001211143y45db17b7ob731a9d3a6e48957@mail.gmail.com>
Date: Thu, 21 Jan 2010 21:45:44 +0200
Message-ID: <165941211001211145jb41fb6dy56e2d8ae908db97f@mail.gmail.com>
Subject: ath9k AP mode + IGMP multicast
From: Rytis Ilciukas <zibalas@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to setup a wireless linux router I have DWA-552 for
wireless access. I'm using Alpine-Linux (2.6.30.10-grsec) with hostapd
and igmpproxy. The problem is when i'm trying to watch IPTV on
wireless connnecion wireless connection kind of dies (wired connection
works fine). No ping to router and VLC shows a couple of messed up
frames every 5 seconds or so. I've tried compat-wireless-2.6.30 and
also compat-wireless-2.6.33-rc4 along with 2.6.32 kernel. Got same
results. Tried connecting from my desktop with 802.11n and laptop
802.11g same results.

There's more info in my thread at
http://www.linuxquestions.org/questions/linux-networking-3/wireless-iptv-with-atheros-ath9k-779521/

I would really appreciate any kind of help and I would be happy to
provide any additional info needed.

Regards,
Rick
