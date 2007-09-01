Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12198 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXIAUJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 16:09:15 -0400
Message-ID: <20070901160914.5boewhzzcow4448o@webmail.spamcop.net>
Date: Sat, 01 Sep 2007 16:09:14 -0400
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc  replies
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
	<20070901043557.2498.6553.stgit@dv.roinet.com>
	<1188638228.7585.124.camel@johannes.berg> <1188644091.4146.12.camel@gx>
	<20070901131655.GB4462@tuxdriver.com>
In-Reply-To: <20070901131655.GB4462@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "John W. Linville" <linville@tuxdriver.com>:

> I think we'll just import these into wireless-dev as-is and go from
> there.  If someone spots a huge problem, then hopefully they'll post
> a patch as well. :-)

If you mean the patches I have posted, then yes, please go ahead.  If  
you mean the rest, I'd like to wait for Kalle's reply, as I don't want  
to create merge problems for him.  I'm not good at making radical  
changes myself, so I'd like at least not to be a problem for those  
brave souls who do that part.

-- 
Regards,
Pavel Roskin
