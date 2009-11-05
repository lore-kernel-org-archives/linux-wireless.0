Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49862 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbZKETnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 14:43:11 -0500
Received: by bwz27 with SMTP id 27so364376bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2009 11:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911052024.32608.mb@bu3sch.de>
References: <4af26c2f.v0dYcKOlddHI9QEQ%Larry.Finger@lwfinger.net>
	 <3ace41890911051121u16c7de8cpb97d0be12cdd0aa6@mail.gmail.com>
	 <200911052024.32608.mb@bu3sch.de>
Date: Thu, 5 Nov 2009 19:43:15 +0000
Message-ID: <3ace41890911051143x75151841k3bb5a1c3879bdb80@mail.gmail.com>
Subject: Re: [PATCH] rtl8187: Remove deprecated 'qual' from returned RX status
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 5, 2009 at 7:24 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Thursday 05 November 2009 20:21:39 Hin-Tak Leung wrote:
>> > +                * is derived from the AGC. The arbitrary scaling constants
>> >                 * are chosen to make the results close to the values obtained
>> >                 * for a BCM4312 using b43 as the driver. The noise is ignored
>
> It's not really a good idea to take b43 for reference, because the values/scales
> are chosen pretty arbitrarily in that driver. So you basically end up
> with an arbitrary^2 value.
>
> --
> Greetings, Michael.
>

Well, onee needs to start from something... many users, bug reporters
have often quoted 'I used driver/device X and it shows 90% strength,
yours shows 60%..." and vice versa. They don't know the numbers are
made up in both drivers, just differently :-).

Hin-Tak
