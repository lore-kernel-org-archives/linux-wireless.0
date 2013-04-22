Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33355 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3DVTLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 15:11:55 -0400
Received: by mail-vc0-f174.google.com with SMTP id kw10so6568141vcb.33
        for <linux-wireless@vger.kernel.org>; Mon, 22 Apr 2013 12:11:54 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Apr 2013 21:11:53 +0200
Message-ID: <CANMvdA-YZduHsWXYDqKz+Z+zKXfyxwpcENAXZTEOiZnUHNdjaA@mail.gmail.com> (sfid-20130422_211200_945794_68395A23)
Subject: How to block a concrete channel?
From: Francisco Cuesta <ndarkness@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm working with ath9k driver, and I would like to know how to block
completely a channel/frequency, for instance if the hardware allows to
tune of Channel 14, and I want to completeley block it to.

I do know that on the crda database you can set up some flags like
CHAN_PASSIVE_SCAN or CHAN_RADAR, in order to allow just some
behaviours on that channel, as well as, you can leave out the
frequency of such database in which this channel appears so that
channel would be disabled. But for instance, I have found the state
IEEE80211_CHAN_DISABLED, so how could I proccee in case I wanted to
block the channel 14? Should I set this flag on the band of that
channel? ( This will lead to forbid completely such band right?)

What is more, where are these flags applied? I mean at driver's level,
kernel's level or  nl80211 interface level...

Thank you very much in advance!

regards
