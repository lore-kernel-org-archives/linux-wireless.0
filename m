Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1586 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbYLaP6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 10:58:38 -0500
Date: Wed, 31 Dec 2008 10:57:57 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
Message-ID: <20081231155757.GA26806@hash.localnet> (sfid-20081231_165842_503112_32BAE1EC)
References: <348894.23448.qm@web23108.mail.ird.yahoo.com> <495B82CB.6050205@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <495B82CB.6050205@tuffmail.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 31, 2008 at 02:33:47PM +0000, Alan Jenkins wrote:
> Thanks for the patch.  I tested STD too, and it doesn't seem to hang
> anymore.  I even tested removing the adaptor while the system was
> hibernated.  However, after resume the interface is useless.

Kind of sounds like the hardware is not responding... so this probably
won't help, but you can always give my patches a spin:

    http://bobcopeland.com/kernel/wl/20081214/

Should apply with fuzz.  Just ignore patch 3, also you don't need 
anything special for rtl8187 since the classdev will suspend/resume
on its own and rtl8187 already didn't do anything special for PM.

> Regards
> "Alan J"

Heh!

-- 
Bob Copeland %% www.bobcopeland.com

