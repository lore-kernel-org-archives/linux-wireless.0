Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbaJ2PmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:42:03 -0400
Date: Wed, 29 Oct 2014 17:14:41 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net
Subject: Re: [PATCH 00/31] staging: vt6655: Conversion to mac80211
Message-ID: <20141029091441.GA4852@kroah.com> (sfid-20141029_164733_813116_0625D197)
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2014 at 09:20:10AM +0100, Malcolm Priestley wrote:
> The patches in this series convert the driver to mac80211.
> 
> As well as infrastructure mode the driver now operates in
> IBSS and access point modes.
> 
> Host access point is now working with hostapd in nl80211 mode.
> 
> The driver continues to operate diversity mode in infrastructure mode.
> 
> There is still a lot of work that needs doing particularly remodeling
> rxtx to something similar to vt6656 driver.
> 
> These patches creates huge amount of dead code that will be
> removed in the next series.

I really wanted to apply these, but they wouldn't apply due to other
changes in my branch since you made these.  Actually, I couldn't figure
out what branch you made them against, as they didn't even apply cleanly
to 3.18-rc1.

Can you refresh this series, and your second one, against my
staging-testing branch of staging.git and resend?

thanks,

greg k-h
