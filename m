Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62673 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbZKFA43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 19:56:29 -0500
Received: by ewy3 with SMTP id 3so619185ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 05 Nov 2009 16:56:34 -0800 (PST)
Message-ID: <4AF3743D.3050401@lwfinger.net>
Date: Thu, 05 Nov 2009 18:56:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Remove deprecated 'qual' from returned RX status
References: <4af26c2f.v0dYcKOlddHI9QEQ%Larry.Finger@lwfinger.net> <3ace41890911051121u16c7de8cpb97d0be12cdd0aa6@mail.gmail.com> <200911052024.32608.mb@bu3sch.de>
In-Reply-To: <200911052024.32608.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2009 01:24 PM, Michael Buesch wrote:
> On Thursday 05 November 2009 20:21:39 Hin-Tak Leung wrote:
>>> +                * is derived from the AGC. The arbitrary scaling constants
>>>                 * are chosen to make the results close to the values obtained
>>>                 * for a BCM4312 using b43 as the driver. The noise is ignored
> 
> It's not really a good idea to take b43 for reference, because the values/scales
> are chosen pretty arbitrarily in that driver. So you basically end up
> with an arbitrary^2 value.

When I did that, b43 was the only other device that I had available.
As Hin-Tak said, one has to start somewhere. As we all know, only
relative values are significant, and the absolute value has little
meaning.

Larry
