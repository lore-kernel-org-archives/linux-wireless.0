Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:48171 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030682AbXDJOhv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2007 10:37:51 -0400
Message-ID: <461BA189.9030903@lwfinger.net>
Date: Tue, 10 Apr 2007 09:39:05 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: dragoran <drago01@gmail.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>, Jiri Benc <jbenc@suse.cz>,
	ipw3945-devel@lists.sourceforge.net, jketreno@linux.intel.com
Subject: Re: mac80211 does not support WPA when used with wext
References: <460E2B8C.4030002@gmail.com>	 <200703311700.52792.flamingice@sourmilk.net>	 <f6ca9fed0704081445u5536e596m4ca4caeb44f7f87@mail.gmail.com>	 <200704081754.24937.flamingice@sourmilk.net> <f6ca9fed0704081527j641a4ecat44151e107cab7342@mail.gmail.com> <461B3930.6040203@gmail.com>
In-Reply-To: <461B3930.6040203@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dragoran wrote:
> ioctl[SIOCSIWAUTH]: Operation not supported
> WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
> ioctl[SIOCSIWAUTH]: Operation not supported
> ----
> notice the *ioctl[SIOCSIWAUTH]: Operation not supported* what is 
> SIOCSIWAUTH and how does it not being supproted affect wpa/wext support?

I agree with Dan Williams that this message is not critical. Michael Buesch uses WPA with mac80211, 
and his version doesn't support SIOCSIWAUTH either.

I'm beginning to think that there is a problem with certain AP's. What is the make and model of 
yours? What firmware version is it using? I cannot connect to my Linksys WRT54G V5 with or without 
WPA enabled. I'm running v1.02.00 of the firmware (the latest).

Larry
