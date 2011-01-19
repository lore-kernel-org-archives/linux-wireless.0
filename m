Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65303 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1ASHG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 02:06:26 -0500
Received: by gyb11 with SMTP id 11so142157gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 23:06:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295420717.10758.111.camel@pimenta>
References: <1295379592-6223-1-git-send-email-arik@wizery.com> <1295420717.10758.111.camel@pimenta>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 19 Jan 2011 09:06:10 +0200
Message-ID: <AANLkTik=UbE1Qp5oA4AKvGOnT=xO858iqxx4EQEUs=xu@mail.gmail.com>
Subject: Re: [PATCH v2] wl12xx: Add channel 14 to list of supported 2ghz channels
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 09:05, Luciano Coelho <coelho@ti.com> wrote:
>
> On Tue, 2011-01-18 at 20:39 +0100, Arik Nemtsov wrote:
> > Channel 14 is only supported in Japan (JP country code in).
> > The FW limits tranmissions to CCK only on this channel.
> >
> > Tested in both STA and AP modes to work correctly.
> >
> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > ---
>
> Good, thanks Arik!
>
> I guess instead of (JP country code in) you meant (JP country code in
> regdb), right? I'll fix that manually before applying.
>

Yes Luca. Thanks.

Regards,
Arik
