Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2F0PzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:55:12 -0400
Date: Wed, 27 Jun 2012 21:26:19 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Paul Stewart <pstew@chromium.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	<manschwetus@googlemail.com>
Subject: Re: 3.4.x bug with channel type changes
Message-ID: <20120627155616.GA5183@vmraj-lnx.users.atheros.com> (sfid-20120627_175519_491805_3565C18D)
References: <1340805097.11012.24.camel@jlt3.sipsolutions.net>
 <1340805979.11012.34.camel@jlt3.sipsolutions.net>
 <CAMcMvsjmbM1NXtiHhcGeDkim6PuTJKqoXfkvU4xxWJaqEP3-qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMcMvsjmbM1NXtiHhcGeDkim6PuTJKqoXfkvU4xxWJaqEP3-qA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 07:58:08AM -0700, Paul Stewart wrote:
> On Wed, Jun 27, 2012 at 7:06 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2012-06-27 at 15:51 +0200, Johannes Berg wrote:
> >
> >> Now, the reason I'm writing all this in an email and not a commit log is
> >> that I don't know what the TX/RX channel type usage should be, or if
> >> maybe it should be "if (queues_stopped) wake_queues()" or something like
> >> that... Can you tell me what it should be?
> >
> > Something like this should help, of course, but maybe there are other
> > issues in this area too?
> >
> > http://p.sipsolutions.net/3e89ee42463d6cc9.txt
> 
> This looks good to me, however, Rajkumar might be better at answering
> the question of correctness since I was only involved as far as
> changing the rate control, and didn't (intend to) change anything as
> far as queues go.
>
The changes are good to me.

-Rajkumar
