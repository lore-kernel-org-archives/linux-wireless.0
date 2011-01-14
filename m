Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33842 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758153Ab1ANSYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:24:34 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 10:24:16 -0800
Date: Fri, 14 Jan 2011 23:53:47 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Tomasz <dot@poczta.fm>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k  - cannot reconnect few meters from the antenna
Message-ID: <20110114182345.GB11920@vmraj-lnx.users.atheros.com>
References: <loom.20110113T233025-142@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <loom.20110113T233025-142@post.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 04:16:37AM +0530, Tomasz wrote:
> Hi All
> I've spend a lot of time on this issue and I cannot fix it, thus I am asking for
> help
> It looks like that:
> 
> I am running wireless access point based on:
> Ubuntu 10.04  vmlinuz-2.6.32-27-generic
> compat-wireless-2010-12-26
> hostapd 0.7.3 (wpa/wpa2)
> Dnsmasq version 2.52
> Zotac Ion board
> Minipcie card: ieee80211 phy0: Atheros AR9285 Rev:2
> ath9k driver
> Single antenna (but the behaviour with two antenna is similar)
> 
> Everything works perfectly fine when I am within the few meters from the antenna.
> So the clients are connecting and I get 25 mbps data rates.
> But if more then 10 meters from the antenna strange things are happening.
> - If I am connected to the network and will walk away everything works perfect.
> - But if i disconnect (disassociate) when I am away I cannot connect back. -
> this also means I cannot connect when turning the notebook on :)
> - if I go closer to antenna I am able to connect and while walking away the
> connection seems perfectly stable ...
Hi Tomasz,

Do you have any interference with the oper channel? Please enable debug option
CONFIG_ATH_DEBUG=y in config.mk and modprobe ath9k debug=0x701 and
post dmesg/kern.log 

--
Rajkumar
