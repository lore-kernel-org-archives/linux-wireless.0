Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60450 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761078AbYILU7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:59:37 -0400
Message-ID: <48CAD837.9060909@lwfinger.net> (sfid-20080912_225949_443737_121A8E85)
Date: Fri, 12 Sep 2008 15:59:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: The new regulatory code kills my wireless
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla> <48CAB90C.5090302@lwfinger.net> <20080912191919.GA7722@tesla> <1221250959.5576.10.camel@johannes.berg> <20080912203438.GB7722@tesla>
In-Reply-To: <20080912203438.GB7722@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> 
> Sorry, I forgot to factor in lazy people, that's important. I hope
> there are no lazy distributions.

There may or may not be any of them, but there will be lots of people 
that are running kernels later than the standard for their distro - me 
as one example. Not all of them will have the skills or inclination to 
build CRDA. For them, I expect that the distro kernels will have the 
old stuff enabled as long as that option lives.

Note: The prerequisites for building CRDA should include netlink. That 
was the last stumbling block for me.

Larry
