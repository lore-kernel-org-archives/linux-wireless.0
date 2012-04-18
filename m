Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42287 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2DRQhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 12:37:51 -0400
Received: by wgbdr13 with SMTP id dr13so7711464wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 09:37:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com>
	<4F8DC25E.9090702@broadcom.com>
	<B9AA983D-A169-497D-9C8E-BDBEF2348BB6@gmail.com>
	<4F8E0CBE.6010103@sipsolutions.net>
	<0FC1AE2B-7E32-466B-AC33-F969F4E72B98@gmail.com>
	<CANUX_P38YDFtL-KzKnFHd0+Ca29SUXoY+mGKaDUjConXaf3c9A@mail.gmail.com>
	<4B048FDE-C784-4401-9FEC-16F8CC0B8D59@gmail.com>
	<CANUX_P0FO-P6ZFow15shNpZg6Z8FAPP7AovJH=xUKPyVEMtoBw@mail.gmail.com>
	<FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com>
Date: Wed, 18 Apr 2012 19:37:50 +0300
Message-ID: <CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com> (sfid-20120418_183804_424343_D6F5E11A)
Subject: Re: wlan0 not present
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Feser <dominik.feser@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 18, 2012 at 17:39, Dominik Feser
<dominik.feser@googlemail.com> wrote:
> There it is:
>
> # lspci -x -s 02:00
> 02:00.0 Network controller: Intel Corporation Centrino Advanced-N 6205 (rev 34)
> 00: 86 80 82 00 02 00 10 00 34 00 80 02 10 00 00 00
> 10: 04 00 d0 e2 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 86 80 21 13
> 30: 00 00 00 00 c8 00 00 00 00 00 00 00 0a 01 00 00
>

Ok, you need a fw whose name is iwlwifi-6000g2a-*

can you send the output of

ls /lib/firmware iwlwifi-6000g2a-*


thanks
