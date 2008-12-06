Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.brikks.com ([82.209.166.4]:13976 "EHLO smtp.bredband2.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751585AbYLFRFo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 12:05:44 -0500
Date: Sat, 6 Dec 2008 18:05:37 +0100
From: Mats Johannesson <spamcan1@abrasax.se>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
Message-ID: <20081206180537.717d1791@loke.fish.not> (sfid-20081206_180548_605262_1C5C8A12)
In-Reply-To: <18746.37273.989918.333164@localhost.localdomain>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 6 Dec 2008 20:22:09 +0530 Sujith wrote:
> Mats Johannesson wrote:
> > As the subject says, 2.6.28-rc7-wl git pulled Dec 6 exhibits a
> > kernel panic when doing "iwlist ath0 scan" as root under the ath9k
> > driver. Machine dead, panic LED blinking.
> > 
> > Scan as normal user is OK.
> > 
> 
> Can you check if this makes any difference ? Thanks.
[patch snipped]

It fixes the kernel panic with root "iwlist ath0 scan" but after that
the network dies without a sign of any kind (iwlist, ifconfig etc is
normal, nothing in logs). Tried several times. Boot -> ping local and
remote machine OK -> "iwlist ath0 scan" -> ping nonfunctional: 'no
route to host' or some such message.

Sending you a picture of the panic in a personal letter. Don't know if
it will do any good since only the last part is visible on screen.
Taken outside of X in plain terminal. Tried to snap from inside X in
both an xterm and a kterm but the panic message never reaches that
high in the chain. Instant death!

/Mats
