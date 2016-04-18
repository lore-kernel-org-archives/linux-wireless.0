Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35497 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbcDRRHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 13:07:04 -0400
Date: Mon, 18 Apr 2016 10:07:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lauri Kasanen <cand@gmx.com>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] carl9170: Clarify kconfig text
Message-ID: <11418613.XH7h8m2RjK@debian64> (sfid-20160418_190727_596594_CFF0EEAB)
In-Reply-To: <87r3e2kgwy.fsf@kamboji.qca.qualcomm.com>
References: <20160416113312.8de2266358165182bb4b4a15@gmx.com> <3244016.0TmHG3E4A9@debian64> <87r3e2kgwy.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, April 18, 2016 07:42:05 PM Kalle Valo wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > On Monday, April 18, 2016 06:45:09 PM Kalle Valo wrote:
> >> Lauri Kasanen <cand@gmx.com> writes:
> >> 
> >> > --- a/drivers/net/wireless/ath/carl9170/Kconfig
> >> > +++ b/drivers/net/wireless/ath/carl9170/Kconfig
> >> > @@ -5,12 +5,10 @@ config CARL9170
> >> >  	select FW_LOADER
> >> >  	select CRC32
> >> >  	help
> >> > -	  This is another driver for the Atheros "otus" 802.11n USB devices.
> >> > +	  This is the mainline driver for the Atheros "otus" 802.11n USB devices.
> >> >  
> >> > -	  This driver provides more features than the original,
> >> > -	  but it needs a special firmware (carl9170-1.fw) to do that.
> >> > -
> >> > -	  The firmware can be downloaded from our wiki here:
> >> > +	  It needs a special firmware (carl9170-1.fw), which can be downloaded
> >> > +	  from our wiki here:
> >> >  	  <http://wireless.kernel.org/en/users/Drivers/carl9170>
> >> 
> >> Why even mention anything about a "special firmware" as the firmware is
> >> already available from linux-firmware.git? 
> >
> > Yes and no. 1.9.6 is in linux-firmware.git. I've tried to add 1.9.9 too
> > but that failed.
> > <http://comments.gmane.org/gmane.linux.kernel.wireless.general/114639>
> 
> Rick's comment makes sense to me, better just to provide the latest
> version. No need to unnecessary confuse the users. And if someone really
> wants to use an older version that she can retrieve it from the git
> history.
Part of the fun here is that firmware is GPLv2. The linux-firmware.git has
to point to or add the firmware source to their tree. They have added every
single source file to it.... instead of "packaging" it in a tar.bz2/gz/xz
like you normally do for release sources.

If you want to read more about it:
<http://www.spinics.net/lists/linux-wireless/msg101868.html>

