Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44227 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2DPF52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 01:57:28 -0400
Received: by qcro28 with SMTP id o28so2930858qcr.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 22:57:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com>
References: <20120413142352.3b927516@destiny.ordissimo> <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
 <CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com>
From: Anisse Astier <anisse@astier.eu>
Date: Mon, 16 Apr 2012 07:57:07 +0200
Message-ID: <CALUN=qK65XgtG5B-Da9o6oGaSF38TsN6NuNaK5=9-nQ+TMUvtg@mail.gmail.com> (sfid-20120416_075732_151000_CA4A18D0)
Subject: Re: RT5390 not working with rt2800pci
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, RA-Shiang Tu <Shiang_Tu@ralinktech.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	RA-Jay Hung <Jay_Hung@ralinktech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 1:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Anisse,
>
> On Mon, Apr 16, 2012 at 03:33, Anisse Astier <anisse@astier.eu> wrote:
>> On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
>>>
>>> [1] I have many of both, in RT5390(rev 1502) and RT5390F(rev 0502) models. All non working are rev 1502, even if some rev 1502 are working.
>>
>> To clarify, Revs 0502, marked RT5390L are all working, and can be
>> ignored for the purpose of this discussion.
>>
>> The only non-working revs are 1502, which is the model marked
>> "RT5390RL". This model has zero google results apart from this
>> discussion, so I'm guessing it might be new, hence not much tested and
>> not supported.
>
> This is likely to be the case, I'm sure that the rt2x00 developers
> will probably have support in the driver once RaLink gives them the
> code / info needed.
>
>> Why some cards work and others don't is a mystery.
>
> Not really, old cards generally work, current cards that have been out
> for a little while generally work, and bleeding edge,
> just-released-yesterday cards tend not to.
What I meant is that in the set of RT5390RL cards, some work, some
don't, consistently, and I cannot find any difference between them.

>
> In general, the kernel developers only add support for a card once
> it's been released.
Indeed, and once someone reports they exist ;-)

>
> Thanks,
>
> --
> Julian Calaby
>
> Email: julian.calaby@gmail.com
> Profile: http://www.google.com/profiles/julian.calaby/
> .Plan: http://sites.google.com/site/juliancalaby/
