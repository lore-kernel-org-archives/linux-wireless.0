Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41178 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751197Ab3AGGhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 01:37:50 -0500
Message-ID: <1357540670.21481.38.camel@joe-AO722> (sfid-20130107_073815_746039_6026251C)
Subject: Re: [RFC PATCH] vsprintf: Add %p*D extension for 80211 SSIDs
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	stas.yakovlev@gmail.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Sun, 06 Jan 2013 22:37:50 -0800
In-Reply-To: <50EA6612.6010506@asianux.com>
References: <50E82D7D.4090107@asianux.com>
	 <1357396966.21156.4.camel@joe-AO722> <50EA37CE.1090901@asianux.com>
	 <1357528746.4940.31.camel@joe-AO722> <1357534195.21481.31.camel@joe-AO722>
	 <50EA6612.6010506@asianux.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-07 at 14:07 +0800, Chen Gang wrote:
> 于 2013年01月07日 12:49, Joe Perches 写道:
> > On Sun, 2013-01-06 at 19:19 -0800, Joe Perches wrote:
> >> Maybe these days this should be another vsprintf %p extension
> >> like %pM when the DECLARE_MAC_BUF/print_mac uses were converted.
> >>
> >> (or maybe extend %ph for ssids with %*phs, length, array)
> > 
>   excuse me:
>     I do not quite know how to reply the [RFC PATCH].
>     it would be better if you can tell me how to do for [RFC PATCH], thanks.

You did fine except you unnecessarily quoted the entire original email.
Remember to trim your replies please.  _lots_ of people read these
mailing lists and unnecessary quoting wastes all of their times.

>   at least for me:
>     although it is good idea to add common, widely used features in public tools function.

It's akin to most of the minor uuid/bluetooth mac, etc codes
in vsprintf I've added.

cheers, Joe

