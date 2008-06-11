Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51410.mail.re2.yahoo.com ([206.190.38.189]:32927 "HELO
	web51410.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750880AbYFKUio convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:38:44 -0400
Date: Wed, 11 Jun 2008 13:38:40 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Reply-To: pommnitz@yahoo.com
Subject: Re: [RFC] First CRDA integration work
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890806110309l2600637p82866531cf2f7e6c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <684075.48049.qm@web51410.mail.re2.yahoo.com> (sfid-20080611_223852_382884_0707852E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Luis R. Rodriguez <lrodriguez@atheros.com> wrote am Mi, 11.6.2008:

> Can you elaborate a bit more on it. Why do you need two
> separate WLAN
> devices on one node where each one of them is using very
> different
> regulatory rules?

The interface connected to the amplifier provides long range communication (up to 5km) on reserved channels. The nodes work as routers/APs that provide access to "normal" WLAN devices (this is where the second wireless device comes into play). So:
* two WLAN devices: 1x long range with amplifier, 1x short range as AP
* different regulatory settings: the regulatory rules for the device with amplifier differ from those without amplifier.

> Do they both use the same frequency
> ranges?

This is not required. Currently both use channels in the 2.4GHz range, but there is a very good chance that we will move into the 5GHz range for the amplified backbone (yes, we know that this will come at a cost).

>   Luis

Thanks for taking an interest
  Joerg


      __________________________________________________________
Gesendet von Yahoo! Mail.
Dem pfiffigeren Posteingang.
http://de.overview.mail.yahoo.com
