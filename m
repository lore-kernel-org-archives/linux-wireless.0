Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:35535 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab2J1WG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2012 18:06:26 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so2110239dak.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2012 15:06:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508C259F.8010909@broadcom.com>
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
	<50880BD0.6080603@candelatech.com>
	<1351093332.10709.5.camel@jlt4.sipsolutions.net>
	<5DA0F03B-BA8C-4D9F-A9F1-0841D6774255@bluemesh.net>
	<50888021.4050300@candelatech.com>
	<CAJ-Vmo=eP8EC2760A_0Ydy3bvG93bhVXfHS9TS3VpAf2vejJ=g@mail.gmail.com>
	<508C259F.8010909@broadcom.com>
Date: Sun, 28 Oct 2012 15:06:26 -0700
Message-ID: <CAJ-Vmo=4ex-m8PXTMu_-XdH76+ny2d+dPgRGd_JJZvB+jwTZag@mail.gmail.com> (sfid-20121028_230630_087801_5F2BFBD8)
Subject: Re: Is Multi-Vif (vaps) Different Channel Operation Supported?
From: Adrian Chadd <adrian@freebsd.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ben Greear <greearb@candelatech.com>,
	Kelly Hogan <kshogan@bluemesh.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 October 2012 11:19, Arend van Spriel <arend@broadcom.com> wrote:

> In my Intersil/Conexant days there was a marketing dude coming up with
> 'time-slicing AP' and there was a way to signal STAs the AP was not able to
> receive. Just needed to be back in time to send its beacon. I chose to
> forget all about the bad idea.

Yup that's what you'd have to do.. with all the timing / settling
issues inherent in that.



adrian
