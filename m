Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:42185 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZDMQ6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:58:11 -0400
Received: by fxm2 with SMTP id 2so2067201fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090413162439.GA30220@hell.pl>
References: <20090410213958.GA12571@hell.pl> <20090411171955.76c48709@vroon.org>
	<20090413162439.GA30220@hell.pl>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 13 Apr 2009 18:57:53 +0200
Message-ID: <69e28c910904130957o68d24c90pf49f44f8db60ece4@mail.gmail.com> (sfid-20090413_185816_417821_40D6BA72)
Subject: Re: ath5k blind to nearby network
To: Grzegorz Nowakowski <krecik@hell.pl>
Cc: Tony Vroon <tony@vroon.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 13, 2009 at 6:24 PM, Grzegorz Nowakowski <krecik@hell.pl> w=
rote:
> On Sat, Apr 11, 2009 at 05:19:55PM +0100, Tony Vroon wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On Fri, 10 Apr 2009 23:39:58 +0200
>> Grzegorz Nowakowski <krecik@hell.pl> wrote:
>> > The symptom is that with both NetworkManager and WICD (and "iwlist
>> > <if> scanning") I don't see my home network on the list. =A0I see =
all
>> > other neighbouring networks around and I'm even able to connect if
>> > any is open.
>>
>> Please doublecheck your wireless regulatory setting. On the default
>> "world" domain, it is unlikely you will be able to see networks on
>> channel 13. You may well have chosen that specific channel because i=
t
>> was so quiet.
>
> Gee, that was so stoopid! =A0You have guessed correctly, the channel =
in
> use was indeed thirteenth and 13 was its number. =A0After reconfiguri=
ng
> the AP to use another one everything seems to be working fine.
>
> But that leaves me with the question: why Windows XP on Atheros and L=
inux
> on Intel didn't have such trouble?

Windows XP auto-configures the regulatory domain based on your
regional settings. Intel cards have semi-hardcoded regulatory
information in their EEPROMs, which allows Linux to automatically
select the right regulatory settings. Atheros cards have no such
firmware-level regulatory enforcement.

>
> Anyway, thanks for suggestion and best regards.
> --
> Grzegorz Nowakowski
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
