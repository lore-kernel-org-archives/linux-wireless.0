Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33658 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbcBJRMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Feb 2016 12:12:47 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 10 Feb 2016 18:12:41 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Subject: Re: [PATCH 8/9] rfkill: Userspace control for airplane mode
In-Reply-To: <1455123205.19821.34.camel@redhat.com>
References: <1454946096-9752-1-git-send-email-jprvita@endlessm.com>
 <1454946096-9752-9-git-send-email-jprvita@endlessm.com>
 <1454947887.5325.8.camel@redhat.com>
 <1455120444.4991.1.camel@sipsolutions.net>
 <1455123205.19821.34.camel@redhat.com>
Message-ID: <ec4b7edcda0a62cd4e36e501f5ad56f9@sipsolutions.net> (sfid-20160210_181252_544677_17E07348)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-10 17:53, Dan Williams wrote:
> Yeah, I get that now.  It's just that to me, something called
> "AIRPLANE_MODE_CHANGE" seems like it should actually change airplane
> mode on/off, which implies killing radios.  I wouldn't have had the
> problem if it was named AIRPLANE_MODE_INDICATOR_CHANGE, which makes it
> clear this is simply an indicator and has no actual effect on anything
> other than a LED.

Yeah, I agree. I'm not even sure that it's a good idea to subsume this 
into the regular operations in the API, although that's obviously the 
easiest extension. I'll need to think about that a bit more with the 
code at hand though.

johannes
