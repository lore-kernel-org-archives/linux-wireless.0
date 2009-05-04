Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:54645 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbZEDP3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:29:17 -0400
Received: by ewy24 with SMTP id 24so4027111ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 08:29:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Alexandre Becholey <alexandre@shockfish.com>
Subject: Re: IEEE80211 Acknowledgement
Date: Mon, 4 May 2009 17:29:13 +0200
Cc: linux-wireless@vger.kernel.org
References: <49FF06BB.2090106@shockfish.com>
In-Reply-To: <49FF06BB.2090106@shockfish.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200905041729.13805.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Just as side information for other readers:

Alexandre is looking into the problem of rt2500usb/rt73usb and
possibly other USB drivers, that they cannot report the ACK status
of frames to mac80211 which is problematic for hostapd.

> I'm trying to catch Acknowlegement frames in the mac80211, but I don't 
> managed to. Thus I'm wondering if they follow another path than the 
> frames that aren't control ones?

Have you made sure that mac80211 has called the configure_filter()
callback function with the FIF_CONTROL flag enabled?

Ivo
