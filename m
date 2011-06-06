Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33307 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1FFVZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 17:25:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110606203252.1854e4d7@sf>
References: <20110605201042.21c86763@sf>
	<BANLkTimLXr1+OLtGGXE2kzccRRG5T-G2mw@mail.gmail.com>
	<20110606203252.1854e4d7@sf>
Date: Mon, 6 Jun 2011 22:25:07 +0100
Message-ID: <BANLkTinEecGCZPCUeLrXu4o+hN9cKGa39w@mail.gmail.com> (sfid-20110606_232534_382951_3CC36587)
Subject: Re: 3.0.0-rc1: dmesg shows 'wlan%d' instead of 'wlan0'
From: julie Sullivan <kernelmail.jms@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Applied this commit on top of 3.0-rc2 and wlan%d switched to wlan0 back.
>
> Thanks!
>
> --
>
>  Sergei
>

Yes, with me too:


before patch application (3.0-rc2):

[   63.837522] wlan%d: authenticate with 00:18:f6:aa:6e:25 (try 1)
[   63.843805] wlan%d: authenticated
[   63.844282] wlan%d: associate with 00:18:f6:aa:6e:25 (try 1)
[   63.846887] wlan%d: RX AssocResp from 00:18:f6:aa:6e:25
(capab=0x411 status=0 aid=2)
[   63.846891] wlan%d: associated

after patch application:

[   69.472955] wlan0: authenticate with 00:18:f6:aa:6e:25 (try 1)
[   69.479356] wlan0: authenticated
[   69.479863] wlan0: associate with 00:18:f6:aa:6e:25 (try 1)
[   69.482425] wlan0: RX AssocResp from 00:18:f6:aa:6e:25 (capab=0x411
status=0 aid=2)
[   69.482428] wlan0: associated


Thanks for the pointer, Shafi.

Cheers
Julie
