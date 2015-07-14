Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35660 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbGNGnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 02:43:37 -0400
MIME-Version: 1.0
In-Reply-To: <55A43355.2070302@gmx.de>
References: <55A43355.2070302@gmx.de>
Date: Tue, 14 Jul 2015 09:43:35 +0300
Message-ID: <CANUX_P3hndEGmrkUrW2=UjDXU2m=V7o01kabnS_7R-t0nQ0mTA@mail.gmail.com> (sfid-20150714_084414_306470_B2227F1A)
Subject: Re: iwlwifi: Microcode SW error detected. Restarting 0x2000000.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jul 14, 2015 at 12:53 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> At a Gentoo (hardened) I experienced - starting with hardened kernel 4.0.6-r1 - the (attached) hickup of the "03:00.0 Network controller: Intel Corporation Wireless 7260 (rev 83)" at a ThinkPad T440s. The network stucks till I do restart the network device using /etc/init.d/net.wlp3s0.

You are not using the latest firmware. Please upgrade to 25.17.12.0.
You'll be able to find the firmware here:
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-7260-12.ucode

Note that users reported an improvement with -13.ucode, but you'll
need 4.1 to use that firmware.
The issue you are facing can be caused by a lot of factor and hence it
is hard to know if the newer versions will fix your problem, but it is
worth trying.
