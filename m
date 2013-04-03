Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:46438 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3DCSVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 14:21:35 -0400
Received: by mail-qa0-f47.google.com with SMTP id hu16so2208232qab.13
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 11:21:35 -0700 (PDT)
Message-ID: <515C732C.1010805@gmail.com> (sfid-20130403_202142_121337_A7F692D8)
Date: Wed, 03 Apr 2013 14:21:32 -0400
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmljYXJkbyBUdWLDrW8=?= <rtpardavila@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [ath5k][802.11p] Deactivate beacon
References: <loom.20130403T092722-24@post.gmane.org>
In-Reply-To: <loom.20130403T092722-24@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ricardo,
	I have not looked at the GCDC patches yet, but it would probably be 
best to implement another nl80211_iftype as "NL80211_IFTYPE_WAVE" for 
example.

On 04/03/2013 03:30 AM, Ricardo Tubío wrote:
> My name is Ricardo Tubío and I am currently trying to use GCDC patches for the
> 'ath5k' driver in order to meet IEEE 802.11p automotive requirements. I would
> like to know if somebody has either a patch for deactivating the beacon or can
> help me in locating the code where the beacon is implemented.
>
> Thank you very much in advance.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
