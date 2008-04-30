Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:43574 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYD3JuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 05:50:07 -0400
Subject: Re: rt61pci current wireless testing git gives kernel oops
From: Bas Hulsken <bhulsken@hotmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1209406716.29025.18.camel@johannes.berg>
References: <1209147056.2955.7.camel@Bas>
	 <200804252031.56605.IvDoorn@gmail.com>
	 (sfid-20080425_203116_969250_F59BCB3A)  <1209406716.29025.18.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 11:45:33 +0200
Message-Id: <1209548733.5814.3.camel@Bas> (sfid-20080430_115002_180485_4D575957)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, 2008-04-28 at 20:18 +0200, Johannes Berg wrote:
> > > the interface goes up well, but I get an oops as soon as I run hostapd,
> > > seems something with debugfs. This shows up in dmesg, let me know if you
> > > need any more info.
> 
> Bas, can you reproduce this issue? Could you try the patch below?
> 
> johannes

with your patch applied I can no longer reproduce this issue, and I've
tried running hostapd at least 5 times. Without your patch, I could
reproduce it two out of two times.

thanks,
Bas


