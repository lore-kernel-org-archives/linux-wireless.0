Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40760 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2LPCLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2012 21:11:37 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1866933eaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 15 Dec 2012 18:11:36 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 15 Dec 2012 21:11:36 -0500
Message-ID: <CANa_0w32t0RCk2sMqz9W19FO66nMetYLOFoymEprMj_ThvT_hw@mail.gmail.com> (sfid-20121216_031141_378915_BE96F128)
Subject: AWUS036NHA and capturing only good packets
From: Jason Mclaughlin <mcjason@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm happening to notice that the fcsfail option is default on with
this wireless adapater and the ath9k driver.

most people ask how do you turn fcsfail on, but I want to ask how do
you turn it off so you don't capture bad packets.

i've tried "iw wlan2 set monitor otherbss control", without the
fcsfail flag, and it's still capturing bad packets.


I've done much searching and can't find anything that works.
