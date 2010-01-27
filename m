Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51223 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0A0KSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2010 05:18:10 -0500
Received: by bwz27 with SMTP id 27so4368243bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2010 02:18:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4dd58f491001270211n7ce690bbm9506d97a50bde8b7@mail.gmail.com>
References: <4dd58f491001270211n7ce690bbm9506d97a50bde8b7@mail.gmail.com>
Date: Wed, 27 Jan 2010 10:18:07 +0000
Message-ID: <4dd58f491001270218t4eaac711xcb42658f8fbf375c@mail.gmail.com>
Subject: Re: wlan/eth bridge stops working after a while: how to diagnose?
From: Alexey Yudichev <ayudichev@gmail.com>
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've got ubuntu 9.10 (hostapd 0.6.9) + compat-wireless-2009-12-11 and
the box is acting as a basic wireless internet router. Driver is ath9k
and server adapter is D-Link DWA-547. All is working fine for 2-3 days
until all of a sudden wireless client (MacBook Pro) stops pinging any
hosts on a local network. The wireless association remains and hostapd
logs are not showing anything unusual. Restarting hostapd or even
networking does not help (although I believe restarting networking
does not work well on ubuntu anyway). Only rebooting the server helps.


What would you advise to check/debug or otherwise what would be the
best approach to diagnose the problem? I don't see anything
interesting in dmesg, messages or daemon.log at this point.

Thanks!
