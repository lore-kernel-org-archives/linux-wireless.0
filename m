Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:33168 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752100AbXDHXbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 19:31:41 -0400
Message-ID: <46197B90.8050408@lwfinger.net>
Date: Sun, 08 Apr 2007 18:32:32 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704081135.33106.flamingice@sourmilk.net> <46196C03.4070003@lwfinger.net> <200704081902.23238.flamingice@sourmilk.net>
In-Reply-To: <200704081902.23238.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 08 April 2007 18:26, Larry Finger wrote:
>> Link Quality=216/146  Signal level=-197 dBm  Noise level=-63 dBm
>>
> Is this before or after your "bcm43xx-mac80211: Fix error in initiallizing max 
> RSSI and max signal" patch?
> 
> -Michael Wu


This is after that patch.

Larry
