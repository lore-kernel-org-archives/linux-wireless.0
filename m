Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36035 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0AYPMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 10:12:18 -0500
Received: by fxm7 with SMTP id 7so111693fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 07:12:17 -0800 (PST)
Subject: Re: mac80211: Breakage in software encryption (iwl3945)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B5CD773.1010107@scram.de>
References: <1264277460.13250.10.camel@maxim-laptop>
	 <1264330613.23766.17.camel@johannes.local>
	 <1264357465.4152.4.camel@maxim-laptop>  <4B5CD773.1010107@scram.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 17:10:50 +0200
Message-ID: <1264432250.6336.1.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-01-25 at 00:27 +0100, Jochen Friedrich wrote: 
> Hi Maxim,
> 
> >> On Sat, 2010-01-23 at 22:10 +0200, Maxim Levitsky wrote:
> >>> I updated the kernel and lost connection to my WPA2
> >>> AP. Strangely the WPA handshake completes, but DHCP not.
> >> What did you upgrade to?
> > latest -git of wireless-testing
> 
> I have the same problem since compat-wireless-2010-01-20 with 
> iwl3945. compat-wireless-2010-01-15 works OK. However, as i don't 
> use any module parameters, i guess i'm using hw encryption.
Nether did I use any parameters. However software encryption is the
default today, this is why nobody notice it is broken.

I use WPA2 thus CCMP.


Best regards,
Maxim Levitsky

