Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59496 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756098AbXK0WB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 17:01:27 -0500
Message-ID: <474C93B5.2070300@lwfinger.net> (sfid-20071127_220134_102258_4458A8B1)
Date: Tue, 27 Nov 2007 16:01:25 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Mattias Nissler <mattias.nissler@gmx.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [RFC/T][PATCH][V3] mac80211: Exponential moving	average	estimate
 for rc80211_simple
References: <1196112605.8318.6.camel@localhost>	 (sfid-20071126_213044_416915_EDBE20FD) <1196172814.6058.23.camel@johannes.berg>	 <474C32CB.9090301@lwfinger.net> <1196199044.8298.15.camel@localhost>
In-Reply-To: <1196199044.8298.15.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mattias Nissler wrote:
> 
> Good to hear. I've tested it with rt61pci and rt73usb. I guess you
> tested b43[legacy]. Any other test results, especially in low signal
> quality situations would be of great help.

Sorry I wasn't clearer. I have tested V3 of the patch on a BCM4311/2 using b43. So far, it has only
been tested with strong signal.

Larry
