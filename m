Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49042 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345AbZLRTBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 14:01:16 -0500
Message-ID: <4B2BD170.40102@am.sony.com>
Date: Fri, 18 Dec 2009 11:01:04 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Hamish Guthrie <Hamish.Guthrie@sonycom.com>
Subject: Re: [PATCH v2] ps3_gelic_wireless: Fix build failure due to missing
 WEXT_PRIV
References: <1261115574.2173.18.camel@pasglop>	 <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>	 <4B2BC8E6.9090007@am.sony.com> <1261161036.14206.3.camel@johannes.local>
In-Reply-To: <1261161036.14206.3.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2009 10:30 AM, Johannes Berg wrote:
> On Fri, 2009-12-18 at 10:24 -0800, Geoff Levand wrote:
>> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> 
>> The option to support the old style PSK interface in the PS3
>> GELIC wireless drivers requires CONFIG_WEXT_PRIV to be set
>> 
>> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
>> ---
>> v2: Added 'depends on WLAN'.
> 
> Won't you want 'depends on WLAN' for GELIC_WIRELESS instead of here?

Yes, that seems correct.  I'll post an update v3.

-Geoff

