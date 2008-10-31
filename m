Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44243 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbYJaSxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:53:34 -0400
Date: Fri, 31 Oct 2008 10:54:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?T25kxZllaiBLdcSNZXJh?= <ondrej.kucera@centrum.cz>
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, jikos@suse.cz
Subject: Re: PROBLEM: Led for wifi blinking all the time
Message-ID: <20081031145434.GB4310@tuxdriver.com> (sfid-20081031_195337_543316_90516B5C)
References: <490A5D39.1090605@centrum.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <490A5D39.1090605@centrum.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 02:19:53AM +0100, Ond=C5=99ej Ku=C4=8Dera wrote=
:
> Hello,
>
> this is my first kernel bug report ever so I'm not 100% sure about th=
e =20
> protocol but I'll try my best...
>
> After upgrading to 2.6.27 the wifi led starts blinking right after =20
> connecting to the network and then continues blinking even when there=
's =20
> no network traffic at all. This wasn't happening before, the led used=
 to =20
> be just "on" when I was connected but not generating any traffic.
>
> Up to kernel 2.6.26.5 (the last 2.6.26.* kernel in my distribution - =
=20
> ArchLinux) the behavior was correct, the problem first occurred with =
=20
> 2.6.27 and is present up to 2.6.27.4 (the last of 2.6.27.* I've tried=
). =20
> The driver used is iwl3945, the corresponding line from lspci:
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG =20
> Network Connection (rev 02)
>
> If any other information is relevant, please tell me and I'll try to =
=20
> provide it, too.

I'm pretty sure this is how the iwlwifi team wants the LEDs to work...

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
