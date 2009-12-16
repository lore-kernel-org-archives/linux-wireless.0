Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:61763 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZLPLrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 06:47:21 -0500
Message-ID: <4B28C8AC.2000300@nokia.com>
Date: Wed, 16 Dec 2009 13:46:52 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/31] wl1271: patches for wk50
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Coelho Luciano (Nokia-D/Helsinki) wrote:
> Hi,
> 
> These are the patches that have resulted from a one-week debug and
> implementation camp with TI.  Mostly bug fixes and improvements, but also we
> now added support for a new version of the firmware.
> 
> With these patches, the driver should be pretty much functional, even though
> there are still a couple of known bugs.
> 
> In v2:
> 
> * use channel max_power configuration instead of hacking the tx_power to 25dBm
> * removed some lame internal bug tags
> * fixed my own email address in one of the s-o-b tags

I noticed that you haven't taken this patches in yet.  It would be nice to have 
them in 2.6.33, since they make our driver much more usable.

I'm just checking, because I mentioned that it would be nice to send pull-reqs 
to you, but I don't have the system ready yet, so at least until further notice, 
it would be nice if you could take my patches directly.


-- 
Cheers,
Luca.
