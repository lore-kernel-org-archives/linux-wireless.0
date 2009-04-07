Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:62964 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZDGMyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 08:54:15 -0400
Received: by qw-out-2122.google.com with SMTP id 8so2919932qwh.37
        for <linux-wireless@vger.kernel.org>; Tue, 07 Apr 2009 05:54:13 -0700 (PDT)
Subject: Re: Making promisc mode work with WPA encryption?
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <87ocv9hxeo.fsf@litku.valot.fi>
References: <1239063352.4705.40.camel@maxim-laptop>
	 <87ocv9hxeo.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 15:54:07 +0300
Message-Id: <1239108847.15015.6.camel@maxim-laptop> (sfid-20090407_145418_915246_41A73E48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-04-07 at 07:59 +0300, Kalle Valo wrote:
> Maxim Levitsky <maximlevitsky@gmail.com> writes:
> 
> > This means kernel can't automatically decrypt other stations traffic.
> > But I could arrange small program that listens to device in monitor or
> > maybe even just promisc mode, and records WPA handshakes. For every
> > handshake it could install the key in kernel driver, so it would use
> > it for decryption, and show the traffic on device in promisc mode. Is
> > it possible to do today? I guess not. All this program has to know is
> > the PSK. (I could even arrange WPA supplicant to do this job - it
> > knows all keys already)
> 
> I think wireshark does something like this. You can enter the PSK in the
> settings and it will decrypt the traffic. I only tried it once and it
> was a long time ago, though.
> 

Exactly.
But for this I have to use monitor, which means that each time I want to
see only network traffic I have to filter by essid, filter out beacons,
etc.
it would be nicer to use promisc mode, and receive decrypted the
ethernet frames.

So can this be done?

Best regards,
	Maxim Levitsky



