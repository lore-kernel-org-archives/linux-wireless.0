Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.schottelius.org ([77.109.138.221]:46699 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 09:07:54 -0400
Date: Wed, 19 Oct 2011 15:07:49 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nico Schottelius <nico-linux-20111017@schottelius.org>,
	Arend van Spriel <arend@broadcom.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111019130749.GD11883@schottelius.org> (sfid-20111019_150812_460609_383F9F20)
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319028563.8416.1.camel@edumazet-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Eric,

Eric Dumazet [Wed, Oct 19, 2011 at 02:49:23PM +0200]:
> 
> Sorry, no CONFIG_LOCKDEP in your config or dmesg. Maybe you sent a
> previous dmesg/config file ?
> 
> Note that you have "CONFIG_LOCKDEP_SUPPORT=y", not "CONFIG_LOCKDEP=y"

Right, make all told me to setup CONFIG_LOCKDEP_SUPPORT=y, but I've
setup CONFIG_LOCKDEP=y manually in .config as I haven't found the entry
in menuconfig.

It seems that this option was removed from .config in the build process,
though.

Should I set it up via

  make -j5 CONFIG_LOCKDEP=y CONFIG_LOCKDEP_SUPPORT=y 

?

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
