Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab1HNMfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 08:35:43 -0400
Received: by fxh19 with SMTP id 19so3116870fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 05:35:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Vladimir Menshakov <vladimir.menshakov@gmail.com>
Subject: Re: carl9170 AP mode stops working in 3.0.x
Date: Sun, 14 Aug 2011 14:35:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAL5UyxpC40VyXstqneP2MZFUTni6C2WBWsGHBYL=CZfJt5Fd2g@mail.gmail.com>
In-Reply-To: <CAL5UyxpC40VyXstqneP2MZFUTni6C2WBWsGHBYL=CZfJt5Fd2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201108141435.37157.chunkeey@googlemail.com> (sfid-20110814_143552_236170_C28EE158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 14 August 2011 12:46:31 Vladimir Menshakov wrote:
> I've been using TL-WN821Nv2 dongle as AP for a year or so. I'm using
> linux x86_64 desktop + hostapd. After upgrading to linux
> 3.0/compat-wireless-3.0-1/2, my AP started freezing after a while
> (Maybe several minutes or so).
> What I've tried so far:
> 1) switching hostapd in b/g mode.
> 2) checked /sys/.../power/autosuspend and various power-saving
> features. (Seems to be unsupported by my device anyway)
> 3) upgrading to firmware-1.9.4 + latest compat-wireless version.
> 
> Sometimes restarting hostapd helps, sometimes not. I don't see any
> relevant error messages or something suspicious in logs. (Tried
> raising hostapd logs to maximum verbosity)
> The last good configuration was 2.6.39-r3 + compat-wireless-stable-39.1
> 
> How could I help you find/debug this problem? I saw other complaint on
> the mail list and I guess it's similar issue.
http://kernel.org/pub/software/scm/git/docs/git-bisect.html
[I haven't noticed any problems with carl9170 AP, so I need
to know what commit broke the driver [shouldn't be too many]]

What other complaint are you referring to? [got a link?]

Regards,
	Chr
