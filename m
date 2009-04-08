Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:56207 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbZDHQUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 12:20:03 -0400
Received: by gxk4 with SMTP id 4so420053gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 09:20:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DCC641.4010405@gmail.com>
References: <49DCA8E3.3060603@gmail.com>
	 <b6c5339f0904080758k2be9ae3dm1a98b564f3b10867@mail.gmail.com>
	 <49DCC641.4010405@gmail.com>
Date: Wed, 8 Apr 2009 12:20:01 -0400
Message-ID: <b6c5339f0904080920q47a33315j127a0aa2eca84444@mail.gmail.com> (sfid-20090408_182008_539835_99913E8B)
Subject: Re: [Fwd: Re: Trouble Associating with ath5k on AR5212]
From: Bob Copeland <me@bobcopeland.com>
To: Will Keaney <keaneyw@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 8, 2009 at 11:44 AM, Will Keaney <keaneyw@gmail.com> wrote:
> Attached.

Great, thanks for the logs!  I'll look them over when I get a chance.

> I also have to manually set the reg domain to US every time I load th=
e
> ath5k module. =A0I tried configuring wpa_supplicant.conf to do this
> itself, but that doesn't seem to work. =A0It would be nice to have a
> module parameter for setting this at load time.

I may be wrong but I think that only works in wpa_supplicant if you
use -Dnl80211 (instead of -Dwext).

=46WIW in the default world roaming domain you can still connect to mos=
t
APs.  Besides iw/wpa_supplicant, pending patches to ath5k will set the
default regdomain automatically based on the value stored in the eeprom=
=2E

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
