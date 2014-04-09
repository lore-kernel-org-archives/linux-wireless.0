Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.130]:61155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbaDIH6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:58:04 -0400
Message-ID: <5344FD84.1050101@lri.fr> (sfid-20140409_095808_568432_15243F50)
Date: Wed, 09 Apr 2014 09:57:56 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Stefan Pietsch <stefan.pietsch@lsexperts.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwlwifi: Invalid RXON when trying to join IBSS network
References: <534464F9.1080805@sp.consulting.lsexperts.de>	 (sfid-20140408_233636_176148_44D5A66B) <1397029645.4964.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1397029645.4964.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2014 09:47, Johannes Berg wrote:
> On Tue, 2014-04-08 at 23:07 +0200, Stefan Pietsch wrote:
>> Dear list,
>>
>> trying to join an IBSS network gives me these kernel messages:
>>
>>
>>
>> [  383.857059] iwlwifi 0000:03:00.0: mac/bssid mcast!
> 
> How did you manage to get a multicast address as the BSSID?

If I remember correctly, the WEXT API doesn't check this.
