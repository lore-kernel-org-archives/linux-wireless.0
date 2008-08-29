Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39210 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYH2H43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 03:56:29 -0400
From: Ganesh Narayanan <Jaiganesh.Narayanan@Atheros.com>
To: Mattias Nissler <mattias.nissler@gmx.de>,
	Ivo van Doorn <ivdoorn@gmail.com>
CC: rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Date: Fri, 29 Aug 2008 13:26:28 +0530
Subject: RE: [Rt2400-devel] [rt2x00] rt2800 progress update (bad news)
Message-ID: <44EE5C37ADC36343B0625A05DD408C484101ACA809@CHEXMB-01.global.atheros.com> (sfid-20080829_095632_762544_6BC55569)
References: <200808272222.53719.IvDoorn@gmail.com>
 <1219955962.4508.43.camel@localhost>
In-Reply-To: <1219955962.4508.43.camel@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mattias,

I remember the Buffalo WLI-UC-G300N USB Station dongle
which apparently is based on RT2800F.

Ganesh.

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Mattias Nissler
Sent: Friday, August 29, 2008 2:09 AM
To: Ivo van Doorn
Cc: rt2400-devel; linux-wireless@vger.kernel.org; John Linville
Subject: Re: [Rt2400-devel] [rt2x00] rt2800 progress update (bad news)

Hi Ivo,

I'll have some spare time during September, and I'd be happy to help you with this. Problem is I don't have rt2800 hardware, but I'd consider to get me a device. Do you have a list of hardware that contains the chip?
Unfortunately the rt2x00 hardware page currently doesn't have information on rt2800 devices.

Cheers,

Mattias

On Wed, 2008-08-27 at 22:22 +0200, Ivo van Doorn wrote:
> Hi,
>
> Several weeks after the deadline for the initial rt2800 version, I
> regret to inform everybody that I still do not have a working driver.
>
> rt2800pci is still incomplete since I have put a lot of focus on the
> rt2800usb driver to get at least a single working driver out.
> Unfortunately rt2800usb remains very stubborn and refuses. The only
> success I have had so far is when I first load the legacy driver and switch to rt2800usb afterwards.
> This means I am missing a register initialization or there is a
> problem with the register initialization ordering.
>
> The result is that it looks like I will cancel all previously
> announced deadlines, and at this time can't give a indication when the first version can be released.
> What I can promise is that rt2800usb will be released first, since
> that driver is most complete, and I am putting all focus on that driver first.
>
> Ivo
>
> ----------------------------------------------------------------------
> --- This SF.Net email is sponsored by the Moblin Your Move Developer's
> challenge Build the coolest Linux based applications with Moblin SDK &
> win great prizes Grand prize is a trip for two to an Open Source event
> anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
