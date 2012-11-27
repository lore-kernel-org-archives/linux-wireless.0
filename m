Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40213 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2K0K1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 05:27:45 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so7915058iea.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 02:27:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
References: <50B470CE.8070402@think.ch>
	<CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
Date: Tue, 27 Nov 2012 11:27:44 +0100
Message-ID: <CAAd0S9DJG5Ldn92fE+rhEsnPzDJrA9wZPkGk_bggfXSn5ty8kA@mail.gmail.com> (sfid-20121127_112749_147758_AF83CC3E)
Subject: Re: regulatory domain settings overwritten
From: Christian Lamparter <chunkeey@googlemail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Erich Titl <erich.titl@think.ch>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 10:55 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Erich,
>
> On Tue, Nov 27, 2012 at 6:50 PM, Erich Titl <erich.titl@think.ch> wrote:
> It's not being completely overridden and it is working as designed.
>
> Firstly, the default country code for all Atheros chips is the USA.
> This is most likely because that's where the company is based.
>
> Secondly, your choice, China, is not being overridden. As the card is
> saying that it's configured for the USA, and you're saying that it's
> in China, the regulatory framework is using the intersection of the US
> and Chinese rules to govern it's output, thereby ensuring that the
> operation of the card complies with all the information it has about
> it's location.
>

Just to avoid further confusion. The country code CH maps to Switzerland,
whereas CN is China.So the second part should be about Switzerland.

Regards,
    Chr
