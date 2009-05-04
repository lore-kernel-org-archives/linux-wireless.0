Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:34880 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454AbZEDPw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 11:52:56 -0400
Subject: Re: [PATCH] add basic support for parsing country information
 element
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241437035.8683.37.camel@johannes.local>
References: <1241413787-3185-1-git-send-email-marcel@holtmann.org>
	 <1241423772.8683.8.camel@johannes.local>
	 <1241423924.8683.9.camel@johannes.local>
	 <1241427107.2899.9.camel@localhost.localdomain>
	 <1241435567.8683.35.camel@johannes.local>
	 <1241437035.8683.37.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 08:52:44 -0700
Message-Id: <1241452364.2903.3.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I've committed everything, and am doing some minor cleanups. I also
> > noticed we don't validate everything as good as we should so I'm adding
> > some support for that.
> 
> I've done that now, and pushed it out, but I think the RSN IE printing
> you added (and I renamed to print_rsn_ie) is missing some input length
> validation, could you take a look at that please? In particular it takes
> the count from the IE, but doesn't verify it fits, I think?

I can have a look at it since it is by no means perfect, but at least we
know have something that allows us to not bother with iwlist.

Btw. I named it WPA2 on purpose since not everybody using iw will
understand that it is actually named RSN. In the end it is your call,
just to let you know why I did it. One of my first patches actually did
use RSN in it :)

Regards

Marcel


