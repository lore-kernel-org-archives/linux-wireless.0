Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32884 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1DVKKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 06:10:50 -0400
Received: by qwk3 with SMTP id 3so221964qwk.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 03:10:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1104220940510.11278@mail.embedromix.ro>
References: <alpine.LFD.2.00.1104212222470.9925@mail.embedromix.ro>
	<4DB092A7.6070100@lwfinger.net>
	<alpine.LFD.2.00.1104220940510.11278@mail.embedromix.ro>
Date: Fri, 22 Apr 2011 12:10:49 +0200
Message-ID: <BANLkTin7haKKU=DRqKXJssRQ1Xja8WmFew@mail.gmail.com>
Subject: Re: [PATCH] Ralink 3090 must load rt3090.bin firmware, not rt2860.bin.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: "Catalin(ux) M. BOIE" <catab@embedromix.ro>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, dwmw2@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Larry, Ivo, thank you for your time.
>
> rt3090.bin comes with linux-firmware package in my Fedora 14.
> In Fedora 15 Beta seems to be the same version (20110304).
> So, they are not up-to-date.

There is already a discussion on linux-wireless regarding this.
Unfortunately all previous attempts to upgrade the firmware seems to
have failed.
Last week a new patch was send, so hopefully that will be applied.

> The plan:
> 1. Remove rt3090.bin from linux-firmware because is confusing.
> 2. Update linux-firmware's rt2860.bin to Larry's (attached) version.

I agree with 1, but unfortunately the policy of linux-firmware is that
the firmware cannot be removed when a driver exists which uses it
(regardless of the presence of that driver inside the latest
linux-kernel release).

I also agree with 2, but that apparently is quite hard. Multiple people
have send patches, I hope that the last attempt of last week will be
accepted and applied.

Ivo
