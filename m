Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60755 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab0I0R5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:57:31 -0400
Received: by fxm3 with SMTP id 3so2059012fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:57:30 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Mon, 27 Sep 2010 19:56:40 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009251034.24993.helmut.schaa@googlemail.com> <B17955D1-62BE-4A7E-8ECD-05FA62BD80B9@kaon.com>
In-Reply-To: <B17955D1-62BE-4A7E-8ECD-05FA62BD80B9@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009271956.41041.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Montag 27 September 2010 schrieb Joshua Smith:
> The change to the REGISTER_BUSY_COUNT did not eliminate the issue. 
> The device still sometimes exhibits this behavior.  (It may be exhibiting
> it less often, but the occurrences are so random, that it's hard for me to
> know for sure.)

Yeah, as I said, just a shot in the dark.

> However, the other fix DID indeed eliminate the kernel crash when I tried
> to restart hostapd, and it also fixed a crash that I experienced when I
> tried to rmmod the rt2800pci module.  So you should definitely mainline
> that patch.

Sure.

> Now that I can retry hostapd and rmmod the modules, I have found that there
> is apparently no software workaround for the case where the DMA busy
> condition does not pass. 

Hmm, maybe there is but we have't found it yet ;)

> I have tried restarting hostapd, and I have tried rmmod'ding all the
> associated modules and modprobing them back in.  Nothing clears the
> condition except a reboot.

Too bad.

> Any other ideas of what I could do to reset the hardware?  I'd love to find
> a "soft" fix for this, rather than having to reboot to clear the condition.

Nothing obviouis at least. So, no without further debugging I don't know what's
going on in your case. Would be interesting if others experience the same
problem.

Helmut
