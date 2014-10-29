Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51705 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbaJ2UeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 16:34:04 -0400
Date: Wed, 29 Oct 2014 13:32:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net
Subject: Re: [PATCH v2 00/34] staging: vt6655: Conversion to mac80211
Message-ID: <20141029203254.GA22055@kroah.com> (sfid-20141029_213408_624375_8999BF93)
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2014 at 05:43:35PM +0000, Malcolm Priestley wrote:
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
> 
> Changes from v1 3 additional patches fixing tsf and rssi issues
> 
> Rebased on staging-testing.

All now applied, very nice work.

greg k-h
