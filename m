Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:34961 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZK2Mvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 07:51:55 -0500
Received: by iwn1 with SMTP id 1so1663127iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 29 Nov 2009 04:52:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87skcqgesb.fsf@raven.defaultvalue.org>
References: <87my37if04.fsf@raven.defaultvalue.org>
	 <87skcqgesb.fsf@raven.defaultvalue.org>
Date: Sun, 29 Nov 2009 13:51:59 +0100
Message-ID: <133e8d7e0911290451p70f07566i1f767176248c6e83@mail.gmail.com>
Subject: Re: ath9k based AP stops responding after half a day or so
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm seeing a similar problem with compat-wireless-2.6.32-rc1 and
hostapd 0.6.9 on a AR9100 (ath9k) mips/ahb based system. This is with
an open access point and without ANI so my guess is that Rob's log
unfortunately does not pinpoint the problem.

I can spend some time on this but like Rob I'm not sure where to
start. Any thoughts? It should be somewhere close to the hardware as a
restart/reload doesn't solve the problem (I haven't been able to try
this though). Anybody know anything related to
beacons/monitor/injection that may deteriorate over time and be
persistent across an rmmod/insmod?

Best regards,

Björn

On Sat, Nov 7, 2009 at 11:18 PM, Rob Browning <rlb@defaultvalue.org> wrote:
>
> Rob Browning <rlb@defaultvalue.org> writes:
>
> > I have an machine that's running a recent compat-wireless (2009-10-17),
> > kernel 2.6.30-2-686 (Debian), and a build of hostapd as of 2009-10-17
> > (08d38568).  The machine also has an AR5008 (ath9k) based PCI card.
> >
> > After the machine reboots, wireless clients can connect to the AP
> > normally for a half day or so.  Then, at some point, all connections
> > fail, and clients cannot even see the network until the machine is
> > rebooted.  Reloading the wireless modules, and restarting hostapd
> > doesn't help.
>
> Just as an update, this problem persists with hostapd as of eb999fef,
> and compat-wireless 2009-11-03.
>
> I'd be happy to provide further information.
> --
> Rob Browning
> rlb @defaultvalue.org and @debian.org; previously @cs.utexas.edu
> GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Venatech AB
Ideon Innovation
Ole Römers väg 12
SE-22370 LUND
Sweden

+46 (0) 46 286 86 20
info@venatech.se
http://www.venatech.se
