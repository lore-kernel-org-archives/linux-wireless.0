Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f174.google.com ([209.85.222.174]:34436 "EHLO
	mail-pz0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0BVS5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 13:57:54 -0500
Received: by pzk4 with SMTP id 4so213914pzk.21
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2010 10:57:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266864150.507.1.camel@jlt3.sipsolutions.net>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	<1266820722-20202-7-git-send-email-juuso.oikarinen@nokia.com>
	<43e72e891002221005q4840593bs8b937d6d82b44b3c@mail.gmail.com>
	<1266864150.507.1.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Feb 2010 10:57:30 -0800
Message-ID: <43e72e891002221057i334b07abq9c1d4ae3adfa4cf5@mail.gmail.com>
Subject: Re: [PATCH 06/22] wl1271: Divided driver to two separate modules
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2010 at 10:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-02-22 at 10:05 -0800, Luis R. Rodriguez wrote:
>> On Sun, Feb 21, 2010 at 10:38 PM, Juuso Oikarinen
>> <juuso.oikarinen@nokia.com> wrote:
>> > From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
>> >
>> > Divided wl1271 driver to wl1271 "core" and wl1271_spi modules in
>> preparation
>> > of integration of the SDIO implementation.
>> >
>> > Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
>> > Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>>
>> Which one is it, Reviewed or SOB? If both then just use SOB.
>
> I disagree. I think we should allow for people just sending on patches
> (say as part of a company hierarchy) w/o giving them the careful review
> the reviewed-by tag should imply.

Technically I think that's right then, since the "Developer's
Certificate of Origin 1.1" does indeed not make mention to a technical
anal review of the code, which for some reason I thought did.

  Luis
