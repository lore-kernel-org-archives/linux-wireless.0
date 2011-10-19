Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.schottelius.org ([77.109.138.221]:58529 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1JSNJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 09:09:28 -0400
Date: Wed, 19 Oct 2011 15:09:23 +0200
From: Nico Schottelius <nico-linux-20111017@schottelius.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Nico Schottelius <nico-linux-20111017@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
Message-ID: <20111019130923.GA5382@schottelius.org> (sfid-20111019_150946_756952_7B6A54BA)
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
 <4E9EC96E.8020303@broadcom.com>
 <1319029529.8416.3.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319029529.8416.3.camel@edumazet-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eric Dumazet [Wed, Oct 19, 2011 at 03:05:29PM +0200]:
> [...]
> make menuconfig
>  -> Kernel hacking
>    -> Lock debugging: prove locking correctness

Alright, rebuilding.

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
