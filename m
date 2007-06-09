Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:33423 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbXFINI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 09:08:58 -0400
Received: from poczta.o2.pl (mx10.go2.pl [193.17.41.74])
	by tur.go2.pl (o2.pl Mailer 2.0.1) with ESMTP id 34EA8230080
	for <linux-wireless@vger.kernel.org>; Sat,  9 Jun 2007 15:08:54 +0200 (CEST)
Date: Sat, 9 Jun 2007 15:06:56 +0200
From: zergavis <zergavis@o2.pl>
Reply-To: zergavis <zergavis@o2.pl>
Message-ID: <679650342.20070609150656@o2.pl>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re[2]: mac80211 "wme.c:398" error
In-Reply-To: <4669A477.9080203@linux.intel.com>
References: <1279688715.20070608205031@o2.pl> <4669A477.9080203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Witam!

W li=9Ccie datowanym 8 czerwca 2007 (20:48:23) napisano:

> zergavis wrote:
>> Hi,
>>=20
>> My name is Pawel Bieniek, and I'm new on this list.
>>=20
>> Today I was trying to compile mac80211 into my kernel (2.6.21.4) on
>> archlinux. I need it to run intel 4965AGN on my toshiba satelite A20=
0
>> notebook.
>>=20
>> Unfortunately, it returns an error during compilation:
> I did a run-time test on 2.6.21-rc1 (32-bit) w/ iwl3945 and CONFIG_NE=
T_SCHED=3Dy

> Let me know if you have any more build issues.

On 2.6.21.4 build ran just perfect.

There were problems with build debug output for mac80211 (same wme.c -
request for member 'wiphy'). I was enab=80le it to compile for test.
Without debug output, it works fine.

Thanks,
pawel


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
