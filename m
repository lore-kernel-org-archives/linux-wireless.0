Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:54659 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbZEDQzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:55:20 -0400
Received: by ewy24 with SMTP id 24so4120068ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 May 2009 09:55:19 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: IEEE80211 Acknowledgement
Date: Mon, 4 May 2009 18:55:17 +0200
Cc: Alexandre Becholey <alexandre@shockfish.com>,
	linux-wireless@vger.kernel.org
References: <49FF06BB.2090106@shockfish.com> <200905041835.35104.IvDoorn@gmail.com> <1241455195.8683.61.camel@johannes.local>
In-Reply-To: <1241455195.8683.61.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200905041855.17435.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 May 2009, Johannes Berg wrote:
> On Mon, 2009-05-04 at 18:35 +0200, Ivo van Doorn wrote:
> 
> > Well I believe the idea would be that (I'll see if I can dig up a reference
> > to the initial discussion about this feature on this list) the driver sets a flag
> > that mac80211 needs to keep a list of all frames send out to the driver and
> > listens for ACK's.
> > 
> > As soon as a ACK was passed from driver to mac80211 it could check if
> > the corresponding frame 
>       ^^^^^^^^^^^^^^^^^^^
> 
> Here's the problem. What I'm saying is that there's no way to knowing
> what the "corresponding frame" is.

Hmm, so would there be any alternatives of fixing this problem?
Because it is quite hard to sell to people that rt2500usb/rt73usb don't
support Master mode, while the legacy drivers (the closed source version)
actually do support it, because they apparently don't care for the ACK status.

Ivo
