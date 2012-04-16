Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42290 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2DPGW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 02:22:58 -0400
Received: by eekc41 with SMTP id c41so1182759eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Apr 2012 23:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALUN=qK65XgtG5B-Da9o6oGaSF38TsN6NuNaK5=9-nQ+TMUvtg@mail.gmail.com>
References: <20120413142352.3b927516@destiny.ordissimo> <CALUN=qJXckZ+_S90QxyvqEAbeu+Fo=cv9VZ9=AkXRJGsFH3yBQ@mail.gmail.com>
 <CAGRGNgVdQgMoBNpJcPJuc608+exeVvpvrGRvvmEggf=GTmOkbg@mail.gmail.com> <CALUN=qK65XgtG5B-Da9o6oGaSF38TsN6NuNaK5=9-nQ+TMUvtg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 16 Apr 2012 16:22:36 +1000
Message-ID: <CAGRGNgVJjVC5ZWRXsrjraT17ivT=HAnnZnhczPfwOw2Za_vatA@mail.gmail.com> (sfid-20120416_082301_866230_E7DEA052)
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

On Mon, Apr 16, 2012 at 15:57, Anisse Astier <anisse@astier.eu> wrote:
> On Mon, Apr 16, 2012 at 1:38 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Anisse,
>>
>> On Mon, Apr 16, 2012 at 03:33, Anisse Astier <anisse@astier.eu> wrote:
>>> On Fri, Apr 13, 2012 at 2:23 PM, Anisse Astier <anisse@astier.eu> wrote:
>>> Why some cards work and others don't is a mystery.
>>
>> Not really, old cards generally work, current cards that have been out
>> for a little while generally work, and bleeding edge,
>> just-released-yesterday cards tend not to.
> What I meant is that in the set of RT5390RL cards, some work, some
> don't, consistently, and I cannot find any difference between them.

Sorry, I misinterpreted what you meant.

So, to clarify, am I right in saying that you have:
 - "RT5390R" cards, PCI revision 0502 which all work
 - "RT5390RL" cards, PCI revision 1502 which work
 - "RT5390RL" cards, PCI revision 1502 which don't work with the
symptoms described above.

Ok, so let's look at this a bit closer: the "iw info" diff you
provided before makes me think that there is some form of regulatory
setting difference between the working and non-working cards. I would
guess that this would be visible in the dmesg output, could you boot
with a working card, save the dmesg, then boot with a non-working
card, save the dmesg, diff them and reply with that diff? I'm guessing
that there would be some lines in there about CRDA or regulatory which
would be different.

Also, what channel is your AP on and what region of the world are you
in? (I'm guessing Europe from your email address, but which country
specifically)

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
