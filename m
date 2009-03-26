Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56105 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbZCZR1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:27:49 -0400
Received: by fxm2 with SMTP id 2so670982fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 10:27:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890903261014j7d050d44wf72ab2c25bc8d625@mail.gmail.com>
References: <b49006ab0903260414xad13bd5y370a47020348c66f@mail.gmail.com>
	 <b49006ab0903260822r35417242qbdc6889543de7072@mail.gmail.com>
	 <alpine.DEB.2.00.0903261752470.11410@aurora.sdinet.de>
	 <43e72e890903261014j7d050d44wf72ab2c25bc8d625@mail.gmail.com>
Date: Thu, 26 Mar 2009 18:27:46 +0100
Message-ID: <b49006ab0903261027y1b7bf7a1ob783b79d1960b48f@mail.gmail.com> (sfid-20090326_182757_851020_7E0E7638)
Subject: Re: Driver Support Linux 2.4.26 zd1211
From: Paco <eyes2k5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I know that with 2.6.x is working but the embedded system I'm
working with only support 2.4.x so... I need to fix the driver to this
version. Upgrade the kernel is not an option.

Thanks anyway

On Thu, Mar 26, 2009 at 6:14 PM, Luis R. Rodriguez <mcgrof@gmail.com> w=
rote:
>
> On Thu, Mar 26, 2009 at 9:55 AM, Sven-Haegar Koch <haegar@sdinet.de> =
wrote:
> > On Thu, 26 Mar 2009, Paco wrote:
> >
> >> Hello everybody, and sorry if I disturb you with something that wa=
s
> >> fixed before.
> >>
> >> I'm trying to setup the zd1211 in Linux 2.4.26-ts11 in the board
> >> TS-7200. I have some drivers that are working only with networks
> >> without encryption. If I try to connect to a network with WEP or W=
PA
> >> encryption, i can not get the access point. I am looking for a new
> >> version of drivers to solve this problem.
> >
> > I think for 2.4.x: forget it.
> >
> > For 2.6.26 it may be possible using compat-wireless-old,
>
> Actually with compat-wireless-old you can go down to 2.6.21 but keep
> in mind that the drivers in there, nor mac80211 has been updated in
> ages.
>
> =A0Luis



--
Un abrazo, ;)
PACO
eyes2k5@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
