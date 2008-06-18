Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:55002 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYFRPbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 11:31:42 -0400
Received: by yw-out-2324.google.com with SMTP id 9so164655ywe.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 08:31:16 -0700 (PDT)
Message-ID: <69e28c910806180831j3625db4h6b93836146349fb@mail.gmail.com> (sfid-20080618_173207_111086_3BA72804)
Date: Wed, 18 Jun 2008 17:31:15 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Bernhard Reiter" <bernhard@intevation.de>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
Cc: linux-wireless@vger.kernel.org, "Greg KH" <greg@kroah.com>
In-Reply-To: <200806181715.20516.bernhard@intevation.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200806181715.20516.bernhard@intevation.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 18, 2008 at 5:15 PM, Bernhard Reiter <bernhard@intevation.d=
e> wrote:
> [Greg gave me the hint to ask here. Please CC me on relevant replies.=
 No need
> to further include him, unless this should go up on the "DriverNeeded=
" page
> later I presume.]
>
> Sitting here a  pc card wireless land adapter.
> id 0x0156, 0x0003, which probably makes it an Agere card.
> cardctl info says:
> "Wireless PC Card Model 0110"
>
> We bought it quite a while ago under the tradename Lancom Airlancer M=
C-11
> from Lancom Systems.
> http://www.lancom-systems.de/AirLancer-MC-11b.117.0.html
>
> Background: We bought it because we thought it has a supported chipse=
t based
> on the old orinocco driver. The vendor announces "linux" supported, b=
ut this
> turned out to be only a driver for Linux 2.4.x.
> Some old stuff (with picture) can be found at:
> ftp://ftp.lancom.de/AirLancer/AirLancer-11/AirLancer-MC-11
> this seems to be Free Software under GNU GPLv2 even.
>
> We could not get it to work with 2.6 and searching the web gave us on=
ly
> reports that it does not work with kernel 2.6.x.
> See http://questier.com/howto.html#Proxim
> (the "local copy" links might haver newer source code)
>
> I've grepped the kernel sources (2.6.24) to try to find the id in a d=
river
> or the source code comment "Agere" to see if source code was taken in=
 from
> the 2.4. driver. To no prevail.
> Even pages like
> http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Linux.Wireless.d=
rivers.802.11b.html
> do not help me.
>
> So I cannot really say: is there a driver which should work with this=
 card in
> Linux 2.6.x and just missed the manufacturer id to recognise it?
> Where did the old Free Software code go? Was it never ported to 2.6?
>
> Thanks,
> Bernhard
> [Please CC me on relevant replies.]
>
> --
> Managing Director - Owner: www.intevation.net       (Free Software Co=
mpany)
> Germany Coordinator: fsfeurope.org. Coordinator: www.Kolab-Konsortium=
=2Ecom.
> Intevation GmbH, Osnabr=FCck, DE; Amtsgericht Osnabr=FCck, HRB 18998
> Gesch=E4ftsf=FChrer Frank Koormann, Bernhard Reiter, Dr. Jan-Oliver W=
agner
>

This appears to be a Wavelan 2 / Orinoco card. Maybe try adding your
device IDs to the Orinoco driver.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
