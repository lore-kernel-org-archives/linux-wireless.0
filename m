Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37639 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbDGIrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 04:47:36 -0400
Message-ID: <1428396454.1841.4.camel@sipsolutions.net> (sfid-20150407_104740_484868_CFF798E0)
Subject: Re: stp broadcast packet not receving with the bridge and
 wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: deepak kumar Pradhan <hydipu@gmail.com>
Cc: linux-wireless@vger.kernel.org, majordomo@vger.kernel.org
Date: Tue, 07 Apr 2015 10:47:34 +0200
In-Reply-To: <CAGKQeFjwX-xU6gxF7E-oyiuJzWpAOqApyrfmcWv3To6pUDAkzg@mail.gmail.com> (sfid-20150406_073740_064246_5A3577A4)
References: <CAGKQeFjwX-xU6gxF7E-oyiuJzWpAOqApyrfmcWv3To6pUDAkzg@mail.gmail.com>
	 (sfid-20150406_073740_064246_5A3577A4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-06 at 10:55 +0530, deepak kumar Pradhan wrote:

> Driver used for Access point is madwifi(0.9.3) and Access point also
> added to the Bridge with the wds support.
> (We don't have access to target source code so we can't modify code on
> target platform)
> 
> So it looks like madwifi + stp interoperability issue.
> Has someone observed this issue. Any inputs on this is much appreciated.
> Please forgive me if I have posted to a wrong list, and please guide
> me where should I post this?

No idea. This list is concerned with upstream wifi development, not
madwifi.

Keep in mind that bridging to a real *client* interface is not actually
possible.

johannes

