Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33143 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbYJ3ASn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:18:43 -0400
Date: Wed, 29 Oct 2008 20:17:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jerry McBride <mcbrides9@comcast.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: B43 randomly and silently dropping connections...
Message-ID: <20081030001739.GG3485@tuxdriver.com> (sfid-20081030_011847_787113_536B3BB3)
References: <200810292010.06442.mcbrides9@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810292010.06442.mcbrides9@comcast.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 08:10:06PM -0400, Jerry McBride wrote:

> SHORT STORY:
> -- Kernel 2.6.25.x with BCM43XX, firmware 4.80.53.0.. just perfect.
> 
> -- Kernels 2.6.26 or higher with B43 and firware 4.150.10.5 good negotiations, 
> but fragile connections that drop randomly and without complaint. B43LEGACY 
> does nothing.
> 
> Any help would be appreciated. I'd really like to get this ironed out. I 
> highly desire to use current kernels.

Are you running a distro kernel?  Or one you have built yourself?

If the latter, have you opened a bug at bugzilla.kernel.org?
Otherwise, have you opened a bug with your distro's bug tracking
system?

Do you have wireshark captures taken with another device in monitor
mode that show these connection drops?

Are you using NetworkManager or wpa_supplicant?  Or just configuring
your connection with iwconfig?  If the latter, consider the former.
If you are using NM, does the connection get re-established
automatically?  Or is NM unable to reestablish the connection?
Use wpa_supplicant directly if NM just doesn't work for you.

It seems clear that posting the same message to the mailing lists
again and again is not resolving the issue for you.  Please perform
the actions requested above (including opening a bug at the appropriate
place) and collect some useable data for us.

Thanks,

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
