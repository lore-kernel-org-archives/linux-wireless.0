Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3C0Rmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:42:32 -0400
Message-ID: <1364406146.8388.12.camel@jlt4.sipsolutions.net> (sfid-20130327_184238_267229_1B706DE4)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Mar 2013 18:42:26 +0100
In-Reply-To: <87li993mug.fsf@sycorax.lbl.gov> (sfid-20130326_215912_863066_7A8A33F1)
References: <87li993mug.fsf@sycorax.lbl.gov>
	 (sfid-20130326_215912_863066_7A8A33F1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-26 at 13:52 -0700, Alex Romosan wrote:
> since v3.9-rc1 i have been unable to reconnect to my access point. the
> access point is a netgear n600 and the my card is a Centrino Advanced-N
> 6205 [Taylor Peak] (rev 34). the last kernel that worked was 3.8. when i
> boot up the laptop the connection is established but if i bring down the
> network with ifdown then i cannot reconnect. this is what i see in the
> logs:
> 
>  iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
>  iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
>  wlan0: authenticate with xx:xx:xx:xx:xx:xx
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
>  wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
>  wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

Btw, since we're looking at the timeout handling -- do you have a
version of this log with timestamps on each line?

johannes

