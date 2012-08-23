Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45359 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2HWFKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 01:10:16 -0400
Received: by obbuo13 with SMTP id uo13so779366obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2012 22:10:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE3CJbmsAnRKCeOjtTk9TXH4zc6UtadCmkdwMT4rnFrDR8UVtg@mail.gmail.com>
References: <CAE3CJbmsAnRKCeOjtTk9TXH4zc6UtadCmkdwMT4rnFrDR8UVtg@mail.gmail.com>
Date: Thu, 23 Aug 2012 10:40:15 +0530
Message-ID: <CAD2nsn3ZUhSR=WpkGR8YAxGVoEp5gD9hmakYh4O7Hsi4rqvU6Q@mail.gmail.com> (sfid-20120823_071100_870636_643BEF57)
Subject: Re: Question about ath9k/mac80211 Driver
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Patrick Connolly <pjc999@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Aug 23, 2012 at 2:26 AM, Patrick Connolly <pjc999@gmail.com> wrote:
> Hello,
>       I'm new to ath9k and in need of some basic/rudimentary help.
>       I'm working with an Access Point that uses the ath9k/mac80211
> driver combination to talk to an Atheros AR9285.  The firmware is
> OpenWrt.
>
>     What is the best command line tool to use to get the driver to
> switch the chip's mode between 'b', 'g', or 'bg' (mixed) mode?  The
> OpenWrt Tools we're currently using ("uci" "wifi") are not talking to
> the driver at all and when we switch settings (between b,g,bg), the
> beacons go out advertising the same rates regardless of the mode.

i don't think ath9k supports this
regarding  commands

   iwconfig eth0 modu 11g
   iwconfig eth0 modu CCK OFDMa
   iwconfig eth0 modu auto


>
>     Any help would be appreciated.
>
> -Patrick
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
