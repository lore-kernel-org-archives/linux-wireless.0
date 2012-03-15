Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031761Ab2COTTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 15:19:51 -0400
Subject: Re: compiler warning in wireless-testing.
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAB3XZEf9oq5GQO_F6zjdo8qTHoDX8-CPozfDouuw7GVzipJpww@mail.gmail.com> (sfid-20120315_201605_580810_4B33938C)
References: <4F6236D0.40505@candelatech.com>
	 <1331836777.3432.31.camel@jlt3.sipsolutions.net>
	 <CAB3XZEeDtJKpSbYB8sMM35rRT7KH5dVuKOWntDBhDp+unRkWGA@mail.gmail.com>
	 <1331837984.3432.42.camel@jlt3.sipsolutions.net>
	 <CAB3XZEf9oq5GQO_F6zjdo8qTHoDX8-CPozfDouuw7GVzipJpww@mail.gmail.com>
	 (sfid-20120315_201605_580810_4B33938C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 20:19:49 +0100
Message-ID: <1331839189.3432.44.camel@jlt3.sipsolutions.net> (sfid-20120315_201954_764771_9ED7F4C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 21:15 +0200, Eliad Peller wrote:

> > What may be possible instead is to replace the second have_sta in the
> > second if with "if (sta)", which may make Ben's compiler a bit happier,
> > but I have no way of even testing that since my compiler doesn't
> > complain to start with.
> >
> that's possible, but then you'll have to initialize sta anyway :)

But then at least that has a purpose you can see :)

johannes

