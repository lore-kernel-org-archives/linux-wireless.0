Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64427 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0CaQcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 12:32:23 -0400
Received: by pwi5 with SMTP id 5so287449pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 09:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100331162442.274220@gmx.net>
References: <20100330155834.56510@gmx.net> <43e72e891003300925s59def37exd515374c34ca73f@mail.gmail.com>
	<20100330171040.56500@gmx.net> <43e72e891003301102i5e8ba846le9e9e76d5e1d4215@mail.gmail.com>
	<20100331083822.203290@gmx.net> <g2o43e72e891003310858ld1ba635fh67342202ddd76f97@mail.gmail.com>
	<u2g43e72e891003310908hd796bee1w45f9d5d2364be41d@mail.gmail.com>
	<20100331162442.274220@gmx.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 31 Mar 2010 09:32:02 -0700
Message-ID: <o2x43e72e891003310932ucfb1783aj10674bb09ab3306@mail.gmail.com>
Subject: Re: [ath9k-devel] Power Save for ath9k
To: =?UTF-8?Q?Lorna_Gonz=C3=A1lez?= <lorna.glez@gmx.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/31 "Lorna González" <lorna.glez@gmx.net>:
> Hi,
>
> I have an Atheros AR928X and today I install the linux version 2.6.34 and iw 0.9.19. but still does not work.
>
> when I use iw phy phy1 info I get:
> Capabilities: SM Power Save disabled
> I can set power on/off but no period or timeout.

Not sure what this period thing is, can't make it out from the man page.

       power  Used to manipulate power management scheme parameters and mode.
              To  set  the  period between wake ups, enter period
`value'.  To set the timeout before going back to sleep, enter timeout
`value'.  To set
              the generic level of power saving, enter saving `value'.
 You can also add the min and max modifiers. By default, those values
are in  sec‐
              onds, append the suffix m or u to specify values in
milliseconds or microseconds. Sometimes, those values are without
units (number of bea‐
              con periods, dwell, percentage or similar).
              off and on disable and reenable power management.
Finally, you may set the power management mode to  all  (receive  all
packets),  unicast
              (receive  unicast packets only, discard multicast and
broadcast) and multicast (receive multicast and broadcast only,
discard unicast pack‐
              ets).
              Examples :
                   iwconfig eth0 power period 2
                   iwconfig eth0 power 500m unicast
                   iwconfig eth0 power timeout 300u all
                   iwconfig eth0 power saving 3
                   iwconfig eth0 power off
                   iwconfig eth0 power min period 2 power max period 4
