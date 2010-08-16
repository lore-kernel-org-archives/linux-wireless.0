Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49999 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab0HPO7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 10:59:41 -0400
Date: Mon, 16 Aug 2010 10:52:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcus Better <marcus@better.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 not associating on 2.6.35
Message-ID: <20100816145221.GB2656@tuxdriver.com>
References: <i485ou$qmb$1@dough.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <i485ou$qmb$1@dough.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 15, 2010 at 09:42:15AM +0200, Marcus Better wrote:
> Hi,
> 
> after upgrading from 2.6.34 to either 2.6.35 or 2.6.35.1, wpasupplicant will 
> no longer associate to my WPA2 access point. The log is full of "Failed to 
> initiate AP scan" messages.
> 
> Is this a known issue? I couldn't quite find out by sifting through the 
> archives... The system is a Thinkpad T61, x86_64, Debian sid, network-
> manager and wpasupplicant 0.6.10-2.
> 
> Cheers,
> 
> Marcus

I'm not aware of this issue.  Please open a bug at bugzilla.kernel.org.
Please include dmesg output for starters.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
