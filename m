Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab1KDIMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 04:12:23 -0400
Subject: Re: A new driver is going to be released
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYgD9DDa+eJgALi3LLF1yQO3ujaxAskpEf1kvcJ19rYwxA@mail.gmail.com> (sfid-20111104_063306_997180_C17EC10D)
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
	 <4EB33B67.6080806@lwfinger.net> <1320372088.29008.0.camel@dcbw.foobar.com>
	 <CAMG6FYgD9DDa+eJgALi3LLF1yQO3ujaxAskpEf1kvcJ19rYwxA@mail.gmail.com>
	 (sfid-20111104_063306_997180_C17EC10D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 09:12:16 +0100
Message-ID: <1320394336.3969.0.camel@jlt3.sipsolutions.net> (sfid-20111104_091227_641234_0EE307C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 06:32 +0100, Dmitry Tarnyagin wrote:
> On Fri, Nov 4, 2011 at 3:01 AM, Dan Williams <dcbw@redhat.com> wrote:
> > It looks like it's mac80211-based and already in drivers/staging/
> > according to the git tree Dmitry pointed to.
> >
> Correct. But I would move it to drivers/net/wireless during submission.

A word of caution: don't attempt that in its current state.

johannes

