Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:53224 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857AbXDIFFd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 01:05:33 -0400
Message-ID: <4619C9D9.5070507@lwfinger.net>
Date: Mon, 09 Apr 2007 00:06:33 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704082031.59934.flamingice@sourmilk.net> <4619B90E.1030403@lwfinger.net> <200704090043.34436.flamingice@sourmilk.net>
In-Reply-To: <200704090043.34436.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 08 April 2007 23:54, Larry Finger wrote:
>> Why would I want to do this?
> Did it fix the output?

With that patch as the only one applied to wireless-dev, I get

Link Quality=69/60  Signal level=-37 dBm  Noise level=-70 dBm

Larry

