Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60108 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1LVLXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 06:23:21 -0500
Message-ID: <4EF31325.2050408@openwrt.org> (sfid-20111222_122324_244910_F250B178)
Date: Thu, 22 Dec 2011 12:23:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: wireless newbie <wnewbie72@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: ar9390 failing AGC calibration on powerpc platform
References: <CAApCBGx28SbbmNpynCpKW9CyAsV5+c_fZ=1k9QAsKnXf4nDQEw@mail.gmail.com> <CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
In-Reply-To: <CAApCBGx7fHuQr87TnppE6FyX9d-1F0huUqgYhjv++8vmfov6zQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-12-22 12:11 PM, wireless newbie wrote:
> I still haven't been able to get this thing working. But I have made
> some tests on other powerpc target (mpc8315 cpu versus mpc8321 cpu on
> my own target) and I can tell that this problem doesn't seem to be
> related to big endian environment. Ar9390 works just fine with
> mpc8315. The difference between those two targets is that 8315 has
> pcie bus whereas my own target's pcie bus is behind pci-to-pcie bridge
> (PLX PEX8112).
> 
> Is anyone aware of any limitations or bugs related to using ar9390
> behind pci-to-pcie bridge? All help is really appreciated.
Have you tried any other PCIe device behind such a bridge?

Maybe you should also check the ASPM settings, though I don't know
enough to give you details on that. It's been covered in various threads
on linux-wireless.

- Felix
