Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44934 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2H2FFX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 01:05:23 -0400
Received: by obbuo13 with SMTP id uo13so276126obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2012 22:05:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <503D14FF.5000309@candelatech.com>
References: <503D14FF.5000309@candelatech.com>
Date: Wed, 29 Aug 2012 10:35:22 +0530
Message-ID: <CAD2nsn2JFEAwB0AauFiEYxj=mC7dNjFZn12EQ0q-aOwXjfZj4A@mail.gmail.com> (sfid-20120829_070604_945838_2BAD1543)
Subject: Re: Does ath9k support beam forming?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Wed, Aug 29, 2012 at 12:29 AM, Ben Greear <greearb@candelatech.com> wrote:
> I saw some RFC patches about beam-forming from 2010, but grepping current
> code doesn't find anything that indicates these patches ever made it
> upstream.
> Of course, I could be looking for the wrong thing...

i think even though the patches are ready for submission,
I think the testing them proved to be very challenging, where there
does not seems to be consistent improvement(if not decrease)
in throughput.  I can be wrong.

>
> Does the current ath9k code support beam-forming?

no. hopefully we can support them(yet we need some considerable
amount of time to test  i suppose).

>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
