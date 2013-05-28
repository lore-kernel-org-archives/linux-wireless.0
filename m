Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934123Ab3E1OZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 10:25:47 -0400
Message-ID: <1369751143.8548.4.camel@jlt4.sipsolutions.net> (sfid-20130528_162550_610565_2D779ECD)
Subject: Re: iwlwifi dmar errors in 3.9.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 May 2013 16:25:43 +0200
In-Reply-To: <CAKb7Uvj5rr1CBxpas3kVKk7zdKDFs7+iVRVT7Q+Ob_mue6-_pQ@mail.gmail.com> (sfid-20130528_155936_875283_78E14BA7)
References: <CAKb7UvhBS6G=1Burf6MfekEnT5vhiy8BKijJ27Fpd=9yBDy9Ng@mail.gmail.com>
	 <1369741393.8548.0.camel@jlt4.sipsolutions.net>
	 <CAKb7Uvj5rr1CBxpas3kVKk7zdKDFs7+iVRVT7Q+Ob_mue6-_pQ@mail.gmail.com>
	 (sfid-20130528_155936_875283_78E14BA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-05-28 at 09:59 -0400, Ilia Mirkin wrote:
> On Tue, May 28, 2013 at 7:43 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2013-05-20 at 17:12 -0400, Ilia Mirkin wrote:
> >> Hello,
> >>
> >> I recently upgraded to 3.9.2 from 3.7.10, and have begun to see some
> >> DMAR errors in my log. Here are a bunch of them:
> >> http://pastebin.com/wgq0JW0S
> >
> > Was there anything in the log _before_ this? Like the device already
> > getting an error, or so?
> 
> Nothing that I felt was relevant, but you be the judge:
> http://pastebin.com/s3rV3UK9

Indeed, nothing that seems relevant, particularly no device error or so.
That seems almost like this _causes_ the device error ... hmm. I feel
this is going to be a tricky bug, probably should buy a laptop with
DMAR ... :)

johannes

