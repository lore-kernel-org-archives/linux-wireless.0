Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39308 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbbJSLx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 07:53:56 -0400
Message-ID: <1445255633.3307.1.camel@sipsolutions.net> (sfid-20151019_135400_868984_DADA4352)
Subject: Re: new regdb file format
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 19 Oct 2015 13:53:53 +0200
In-Reply-To: <CAB3XZEdwybRaKgjQJknVH=iJ+FcPkuh8fhSXaEM9noWdSz1TjA@mail.gmail.com> (sfid-20151019_135237_510478_78FDFDCD)
References: <1444855924.3054.9.camel@sipsolutions.net>
	 <1444856468.3054.17.camel@sipsolutions.net>
	 <CAB3XZEdkpYrLXh1yTJCGA-ZGS0eRuqUhTwnD9WgZaw_g7UvioA@mail.gmail.com>
	 <1445254283.3307.0.camel@sipsolutions.net>
	 <CAB3XZEdwybRaKgjQJknVH=iJ+FcPkuh8fhSXaEM9noWdSz1TjA@mail.gmail.com>
	 (sfid-20151019_135237_510478_78FDFDCD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-19 at 14:52 +0300, Eliad Peller wrote:
> 
> > Hm? Why would you want to do that, if you are allowed to use that 
> > band?
> > 
> The spec seems to indicate the allowed channel set for each operating
> class, and some channels are allowed only in some countries (tables
> E-1 vs. E-2 in 802.11-2012 Annex E).
> 

But that's a different problem in a way - the regulatory database only
tries to encode the legal restrictions, not the spec restrictions.

johannes
