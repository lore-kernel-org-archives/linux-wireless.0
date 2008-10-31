Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.pescomnet.cz ([82.100.5.251]:37390 "EHLO ns.pescomnet.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbYJaBtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 21:49:40 -0400
Message-ID: <490A5D39.1090605@centrum.cz> (sfid-20081031_024956_411797_6FA16546)
Date: Fri, 31 Oct 2008 02:19:53 +0100
From: =?ISO-8859-2?Q?Ond=F8ej_Ku=E8era?= <ondrej.kucera@centrum.cz>
MIME-Version: 1.0
To: yi.zhu@intel.com, reinette.chatre@intel.com
CC: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, jikos@suse.cz
Subject: PROBLEM: Led for wifi blinking all the time
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

this is my first kernel bug report ever so I'm not 100% sure about the=20
protocol but I'll try my best...

After upgrading to 2.6.27 the wifi led starts blinking right after=20
connecting to the network and then continues blinking even when there's=
=20
no network traffic at all. This wasn't happening before, the led used t=
o=20
be just "on" when I was connected but not generating any traffic.

Up to kernel 2.6.26.5 (the last 2.6.26.* kernel in my distribution -=20
ArchLinux) the behavior was correct, the problem first occurred with=20
2.6.27 and is present up to 2.6.27.4 (the last of 2.6.27.* I've tried).=
=20
The driver used is iwl3945, the corresponding line from lspci:
03:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG=20
Network Connection (rev 02)

If any other information is relevant, please tell me and I'll try to=20
provide it, too.

Ond=F8ej


--=20
Cheers,
Ond=F8ej Ku=E8era
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
