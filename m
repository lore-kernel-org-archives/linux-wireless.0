Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:54360 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZFIALg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 20:11:36 -0400
Received: by bwz9 with SMTP id 9so3475257bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 17:11:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ec5eb5d60906071135r4197c08fw464209b501358c83@mail.gmail.com>
References: <ec5eb5d60906071116v564b9623q515ee9db4e5edc59@mail.gmail.com>
	 <ec5eb5d60906071135r4197c08fw464209b501358c83@mail.gmail.com>
Date: Tue, 9 Jun 2009 01:11:36 +0100
Message-ID: <3ace41890906081711s4e16606fne0b54562d1e9d7f5@mail.gmail.com>
Subject: Re: compile error compat-wireless kernel 2.6.28
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: =?ISO-8859-1?Q?Jorge_Mu=F1oz?= <jorgeroden@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 7, 2009 at 7:35 PM, Jorge Muñoz<jorgeroden@gmail.com> wrote:
> I tried to compile compat-wireless-2009-06-05 package and I saw this error
> message  "field 'ops' has an incomplete data type".
> I've got installed ubuntu 9.04 distro based, kernel 2.6.28-11-generic,
> linux-headers-2.6.28-11-generic and build-essential package.
> I have done this several ways with kernel 2.6.27-11-generic succesfully just
> by typing $make, #make install, #make unload (trivial).
>
> These are compilation output messages
> --------------------------------
> jorgeroden@jorgeroden-laptop:~/driversWifi/compat-wireless-2009-06-05$ make
> make -C /lib/modules/2.6.28-11-generic/build
> M=/home/jorgeroden/driversWifi/compat-wireless-2009-06-05 modules
> make[1]: se ingresa al directorio `/usr/src/linux-headers-2.6.28-11-generic'
>   CC [M]
> /home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath/ath9k/hw.o
> In file included from
> /home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath/ath9k/hw.c:20:
> /home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath/ath9k/ath9k.h:469:
> error: el campo ‘ops’ tiene tipo de dato incompleto
> make[5]: ***
> [/home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath/ath9k/hw.o]
> Error 1
> make[4]: ***
> [/home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath/ath9k]
> Error 2
> make[3]: ***
> [/home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless/ath]
> Error 2
> make[2]: ***
> [/home/jorgeroden/driversWifi/compat-wireless-2009-06-05/drivers/net/wireless]
> Error 2
> make[1]: ***
> [_module_/home/jorgeroden/driversWifi/compat-wireless-2009-06-05] Error 2
> make[1]: se sale del directorio `/usr/src/linux-headers-2.6.28-11-generic'
> make: *** [modules] Error 2
> --------------------------
> Thanks
>
> --
> www.jorgeroden.blogspot.com
> FSF member 5687
>
>
>
> --
> www.jorgeroden.blogspot.com
> FSF member 5687
>


Look at the compat-wireless rfkill discussion in the mailing list
archive. Basically you need to revert the rkfill patch.
