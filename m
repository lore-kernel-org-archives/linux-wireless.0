Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbcEYHY1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 03:24:27 -0400
From: "Pukitis, Martins" <martins.pukitis@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Matthias May <matthias.may@neratec.com>
Subject: RE: AP statistics
Date: Wed, 25 May 2016 07:23:59 +0000
Message-ID: <22AF109346512440A803B8D2E69399ECA7AB94@IRSMSX103.ger.corp.intel.com> (sfid-20160525_092430_829960_89537EDC)
References: <22AF109346512440A803B8D2E69399ECA7AA7E@IRSMSX103.ger.corp.intel.com>
 <5744A3B6.6000602@neratec.com>
In-Reply-To: <5744A3B6.6000602@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, as well as
ip -s link
but this is not cfg80211 API.

-----Original Message-----
From: Matthias May [mailto:matthias.may@neratec.com] 
Sent: Tuesday, May 24, 2016 21:56
To: Pukitis, Martins <martins.pukitis@intel.com>; linux-wireless@vger.kernel.org
Subject: Re: AP statistics



On 05/24/2016 05:29 PM, Pukitis, Martins wrote:
> Hi.
> Is there cfg80211 API for getting AP statistics (bytes sent/received, packets sent/received/dropped)? I know there is "get_station", but it reads per station statistics. Stations may disconnect, hence you can't just sum together all station statistics to get per AP statistics.
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

ethtool -S wlan0
should do the trick

BR
Matthias
