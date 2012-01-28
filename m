Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm19.bullet.mail.ukl.yahoo.com ([217.146.183.193]:34414 "HELO
	nm19.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751791Ab2A1UfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 15:35:22 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied rts setting
Date: Sun, 29 Jan 2012 04:35:13 +0800
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <201201290409.07368.lindner_marek@yahoo.de> <CALSq=BbhM6vLOJt9MGi2BhHKO0-NzAm73WohLDy4YC7x9rpDmw@mail.gmail.com>
In-Reply-To: <CALSq=BbhM6vLOJt9MGi2BhHKO0-NzAm73WohLDy4YC7x9rpDmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201290435.14048.lindner_marek@yahoo.de> (sfid-20120128_213541_647376_FBE9E40C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, January 29, 2012 04:26:29 Daniel Halperin wrote:
> >> Can you explain what the low-level behavior of an RTS/CTS "battle" is?
> >> 
> >> Abstractly, the behavior you're describing sounds like a buggy driver
> >> that doesn't obey overheard RTS or CTS packets.
> > 
> > I certainly can explain it but this is for another thread and unrelated
> > to the points raised before.
> 
> Frankly, the correctness of your argument depend on whether there's a
> bug or not. If the difference is -2% normally and +300% in bad
> interference conditions, you're going to lose this debate. If the
> difference is legitimately -99% normally, you might win.

I don't quite follow you here. Are you saying it should only be possible to 
disable rts/cts if I currently have a bug in my rts/cts implementation ?

Keep in mind that I am not asking to disable/ban rts/cts for everyone. I'd 
like minstrel_ht to not override my rts/cts setting if I wish to disable it.

Regards,
Marek
