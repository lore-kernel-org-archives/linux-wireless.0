Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36374 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZDGE7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 00:59:16 -0400
Received: by fxm2 with SMTP id 2so2155969fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2009 21:59:13 -0700 (PDT)
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Making promisc mode work with WPA encryption?
References: <1239063352.4705.40.camel@maxim-laptop>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 07 Apr 2009 07:59:11 +0300
In-Reply-To: <1239063352.4705.40.camel@maxim-laptop> (Maxim Levitsky's message of "Tue\, 07 Apr 2009 03\:15\:52 +0300")
Message-ID: <87ocv9hxeo.fsf@litku.valot.fi> (sfid-20090407_065919_727565_2C45AA09)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> This means kernel can't automatically decrypt other stations traffic.
> But I could arrange small program that listens to device in monitor or
> maybe even just promisc mode, and records WPA handshakes. For every
> handshake it could install the key in kernel driver, so it would use
> it for decryption, and show the traffic on device in promisc mode. Is
> it possible to do today? I guess not. All this program has to know is
> the PSK. (I could even arrange WPA supplicant to do this job - it
> knows all keys already)

I think wireshark does something like this. You can enter the PSK in the
settings and it will decrypt the traffic. I only tried it once and it
was a long time ago, though.

-- 
Kalle Valo
