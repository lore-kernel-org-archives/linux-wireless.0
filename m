Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36490 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab0KEULw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 16:11:52 -0400
Received: by eye27 with SMTP id 27so2002972eye.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 13:11:50 -0700 (PDT)
Message-ID: <4CD46524.5010100@lwfinger.net>
Date: Fri, 05 Nov 2010 15:12:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Josh Lehan <krellan@krellan.com>, Pavel Machek <pma@sysgo.com>,
	linux-wireless@vger.kernel.org
Subject: Re: working usb wifi card, that is still possible to buy
References: <20101103092431.GA21138@pma.sysgo.com> <4CD3CDB1.2090508@krellan.com> <4CD4036E.9090300@lwfinger.net> <ff5cf9bdd23aa256b379521d4c4263d8@localhost>
In-Reply-To: <ff5cf9bdd23aa256b379521d4c4263d8@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2010 12:54 PM, Johannes Berg wrote:
> 
> On Fri, 05 Nov 2010 08:15:26 -0500, Larry Finger
>> The Realtek RTL8712 (aka RTL8192U) and found in the D-Link DWA 130, has
> a
>> driver
>> in 2.6.37 (r8712u). Although not based on mac80211, thus found in
> staging,
>> the
>> driver is extremely stable - my connection never drops out. With an
> 802.11n
>> router, I get transmission throughput of up to 70 Mb/s.
> 
> That definitely requires USB 2 though, and I suspect that
> nobody actually ever tests their devices on a 1.1 only
> controller like Pavel was asking for.

I have tested on 1.1 and it works. The rate mechanism of that non-mac80211
driver ends up at 54M with a maximum transmission rate of 7.1 Mb/s. That must be
the maximum that USB 1.1 can handle.

Larry
