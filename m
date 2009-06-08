Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZFHSrW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 14:47:22 -0400
Subject: Re: Doubt regarding Wifi Driver iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Sivabalan Thirunavukkarasu <siva886@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <be4915c60906060247m7c66b9fdse58991a133e48138@mail.gmail.com>
References: <be4915c60906060247m7c66b9fdse58991a133e48138@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 11:54:24 -0700
Message-Id: <1244487264.20900.186.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Siva,

On Sat, 2009-06-06 at 02:47 -0700, Sivabalan Thirunavukkarasu wrote:
> Hi all,
> 
>       I am using Ubuntu 9.04 64bit running its default kernel
> 2.6.28-11-generic. My doubt is regarding the wireless driver. The card
> my HP HDX16 laptop has is, ( from lspci )
> 
>       02:00.0 Network controller: Intel Corporation PRO/Wireless 5100
> AGN [Shiloh] Network Connection
> 
>       Whenever my card tries to associate with any of my AP's, i get
> the following messages on dmesg.
> 
>      .
>      ..
>      [   73.333572] wlan0: disassociating by local choice (reason=3)
>      [   73.344039] iwlagn: index 0 not used in uCode key table.
>      [   81.500026] Clocksource tsc unstable (delta = -273035428 ns)
>      [   86.239909] wlan0: authenticate with AP 00:1e:40:af:cc:7e
>      ..
>      .
> 
>      I am not clear whether its a bug or what exactly is the problem
> here. Have attached the full dmesg log from start of inclusion of Wifi
> driver with this for reference.
> 
>      Please clarify.

Could you please add your logs to
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2009 ?

Thank you very much

Reinette


