Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f221.google.com ([209.85.218.221]:47473 "EHLO
	mail-bw0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZG1Nee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 09:34:34 -0400
Received: by bwz21 with SMTP id 21so19000bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 06:34:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <efe7343f0907280411y61e8a68dj500c2a74ad1af28a@mail.gmail.com>
References: <c6b1100b0907130127g3d4013c6n3264f79bd74bc9@mail.gmail.com>
	 <200907272035.41193.chris2553@googlemail.com>
	 <1248725279.7440.8.camel@mj>
	 <200907272122.11290.chris2553@googlemail.com>
	 <1248726744.32365.4.camel@johannes.local>
	 <c6b1100b0907280403x697d8816mfb5206e1fb93243a@mail.gmail.com>
	 <efe7343f0907280411y61e8a68dj500c2a74ad1af28a@mail.gmail.com>
Date: Tue, 28 Jul 2009 14:34:32 +0100
Message-ID: <c6b1100b0907280634j4610d077rb30f1f571aac7f36@mail.gmail.com>
Subject: Re: 2.6.31-rc2: Possible regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Luis Correia <luis.f.correia@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/28 Luis Correia <luis.f.correia@gmail.com>:
> Hi Chris

> Can you do a very dumb test for me?
>
> Boot your laptop by adding 'irqpoll' to the kernel command line
> options and see if the problem still occours.
>

Not so dumb a request, actually.  Running -rc4 with the irqpoll
command line option, the laptop has just survived 30 minutes without a
freeze. It can't survive more than 5 minutes without that option.

Chris

> Luis Correia
> rt2x00 project admin
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
