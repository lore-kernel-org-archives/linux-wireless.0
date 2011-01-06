Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32842 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab1AFWXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:37 -0500
Received: by eye27 with SMTP id 27so7434873eye.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 14:23:36 -0800 (PST)
Message-ID: <4D2640F3.3000505@lwfinger.net>
Date: Thu, 06 Jan 2011 16:23:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about iwl3945
References: <4D262CED.5070409@lwfinger.net> <1294347881.25228.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1294347881.25228.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2011 03:04 PM, Johannes Berg wrote:
> On Thu, 2011-01-06 at 14:58 -0600, Larry Finger wrote:
>> Is there any reason why the Intel3495 wireless card using the iwl3945 driver
>> with kernel 2.6.34 does not work in AP mode using hostapd? The message is
>>
>> nl80211: Failed to set interface wlan0 into AP mode
>> nl80211 driver initialization failed.
> 
> Neither 3945 nor 4965 can ever support AP mode due to firmware
> restrictions, sorry.

Thanks. Don't worry, I'm not trying to convert a $600 laptop into a $30 access
point! In fact, I already own 4 APs. A year ago, I wrote a howto for the
openSUSE forums, and someone is trying to follow my prescription. He had some
nasty things to say about the 3945 when I gave him the bad news. Unfortunately,
he will be buying another wifi card and not an AP.

Larry
