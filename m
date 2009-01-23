Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:62960 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756379AbZAWCMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 21:12:13 -0500
Message-ID: <49792772.7020206@lwfinger.net> (sfid-20090123_031215_628152_5924E6A6)
Date: Thu, 22 Jan 2009 20:12:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work
 with iwl3945
References: <1232672850.7913.6.camel@maxim-laptop> <1232674156.4112.1.camel@maxim-laptop>
In-Reply-To: <1232674156.4112.1.camel@maxim-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> I just installed it again with all default options, and still same thing
> I also noticed wierd AP names like:
> 
>  wlan0: associate with AP ffff88005463a9e0

As you have seen, the commit with the bug that prevents a connection has been found.

The funny printing of MAC addresses is due to the newer code using the %pM formatting that
is not present in older kernels. You can ignore that.

Larry
