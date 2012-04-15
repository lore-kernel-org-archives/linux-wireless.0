Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58932 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2DOXiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 19:38:24 -0400
Received: by eaaq12 with SMTP id q12so1134382eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 16:38:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
References: <20120413142352.3b927516@destiny.ordissimo> <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Apr 2012 09:38:03 +1000
Message-ID: <CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com> (sfid-20120416_013840_785622_19D83AC6)
Subject: Re: RT5390 not working with rt2800pci
To: Anisse Astier <anisse@astier.eu>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Anisse,

On Mon, Apr 16, 2012 at 03:33, Anisse Astier <anisse@astier.eu> wrote:
> On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
>>
>> [1] I have many of both, in RT5390(rev 1502) and RT5390F(rev 0502) models. All non working are rev 1502, even if some rev 1502 are working.
>
> To clarify, Revs 0502, marked RT5390L are all working, and can be
> ignored for the purpose of this discussion.
>
> The only non-working revs are 1502, which is the model marked
> "RT5390RL". This model has zero google results apart from this
> discussion, so I'm guessing it might be new, hence not much tested and
> not supported.

This is likely to be the case, I'm sure that the rt2x00 developers
will probably have support in the driver once RaLink gives them the
code / info needed.

> Why some cards work and others don't is a mystery.

Not really, old cards generally work, current cards that have been out
for a little while generally work, and bleeding edge,
just-released-yesterday cards tend not to.

In general, the kernel developers only add support for a card once
it's been released.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
