Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55286 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaBCS6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 13:58:50 -0500
Message-ID: <1391453928.5159.10.camel@porter.coelho.fi> (sfid-20140203_195855_230291_C486C0A0)
Subject: Re: wl12xx interrupt watchdog!!
From: Luca Coelho <luca@coelho.fi>
To: coputer engineer <computer.engineer.ds@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 03 Feb 2014 20:58:48 +0200
In-Reply-To: <52EFABEE.2050004@gmail.com>
References: <52EFABEE.2050004@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-02-03 at 15:47 +0100, coputer engineer wrote:
> I have the wl12xx interrupt watchdog!!

This doesn't mean much.  If it's triggering, it's because something is
stuck (which is what a watchdog does).


> I am using wl127x-fw-4-sr.bin firmware with Rev (6.3.5.0.98 ) with 
> driver version R5_00_18

This is an out-of-tree release.  We don't deal with that in the
community.  If you really want to use such a thing, ask TI.


> The kernel is 2.6.37 with this processor DM368.

This kernel is over 3 years old.  Upgrade or you won't get much help
here either.

--
Luca.

