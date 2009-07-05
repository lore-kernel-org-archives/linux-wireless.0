Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1750 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbZGEMCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 08:02:46 -0400
Date: Sun, 5 Jul 2009 08:02:28 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k AP support?
Message-ID: <20090705120228.GD2132@hash.localnet>
References: <4A381159.70301@wpkg.org> <b6c5339f0906161454tbdaf382k654450a9f1cf8ae7@mail.gmail.com> <4A3AA08E.4050400@wpkg.org> <4A3AA20C.6020908@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A3AA20C.6020908@wpkg.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 10:22:36PM +0200, Tomasz Chmielewski wrote:
> Oh well.
> The above is with hostapd 0.7.0 snapshot.
> With 0.6.9 I can connect and the connection works fine
>
> Is it normal?

I'm not sure -- do you have anything in dmesg?  

I've noticed a strange bug lately where some packets to the STA get dropped
due to some kind of off-by-u32 bug.  I haven't tracked it down yet to
any certain combination of ath5k/w-t/hostapd, though.

-- 
Bob Copeland %% www.bobcopeland.com

