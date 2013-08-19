Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ye0-f171.google.com ([209.85.213.171]:63807 "EHLO
	mail-ye0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3HSEFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 00:05:06 -0400
Received: by mail-ye0-f171.google.com with SMTP id m3so77954yen.30
        for <linux-wireless@vger.kernel.org>; Sun, 18 Aug 2013 21:05:04 -0700 (PDT)
Message-ID: <5211996B.4060800@gmail.com> (sfid-20130819_060511_263331_0EA61288)
Date: Mon, 19 Aug 2013 16:04:59 +1200
From: chris <chgans@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WiFi roaming question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I have setup a WiFi infrastructure with several APs connected by 
ethernet, with only one AP acting as the gateway/dhcp server.
It is a "mixed band" infrastructure (2.4/5GHz).

My goal was to see how, as a WiFi client, I would have to manage which 
access point to connect to.

My environment is a custom embedded Linux system with connman and 
wpa_supplicant.

It turned out that, as a client, I don't have to bother with roaming 
stuff, it simply works out of the box.

Though, I have a couple of questions regarding this OOBX (new buzz word 
seen here and there for "out of the box experience" :) ).
- At which level the roaming is done? Is it at the WiFi kernel stack 
(cfg/mac 80211), at driver level, or at chipset/firmware level or a mix 
of them?
- Can I change my setup, so that I have control over the roaming?
- Is it a good idea to try to manage that myself from userspace?

My usecase is a set of industrial devices that needs to connect to a 
WiFi network (either a unique AP or a set of APs).
On top of that I have to manage a special case where, for whatever 
reason, the user would have forgotten to switch off somes APs, these APs 
shouldn't be on might then interferes with the running system.

I know my questions are a bit broad, but I would appreciate if some one 
could give me some hints or even better point me to some Linux centric 
papers/articles.

Regards,
Chris

PS: I've found some documentation about IAPP, 802.11i, 802.11F, L2 vs L3 
roaming (FWIU wifi vs IP), ... But nothing really clear to me and none 
of them speaks about Linux compatibility/implementation.


