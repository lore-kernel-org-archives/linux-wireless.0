Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8047 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0BWURy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 15:17:54 -0500
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make
 some  functions static
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f1002200730t46298538k30930ed52255f06e@mail.gmail.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
	 <20100219134448.GA2844@tuxdriver.com> <1266621325.25707.14.camel@mj>
	 <b6c5339f1002200730t46298538k30930ed52255f06e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 23 Feb 2010 15:17:42 -0500
Message-Id: <1266956262.16604.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-02-20 at 10:30 -0500, Bob Copeland wrote:
> On Fri, Feb 19, 2010 at 6:15 PM, Pavel Roskin <proski@gnu.org> wrote:
> > On Fri, 2010-02-19 at 08:44 -0500, John W. Linville wrote:
> >> On Thu, Feb 18, 2010 at 08:28:02PM -0500, Pavel Roskin wrote:
> >> Any reason not to just remove those functions instead of commenting
> >> them out?
> >
> > I'm fine either way.  I tend to clean up more aggressively if I know
> > that nobody will miss that code.  I wasn't sure in this case.
> 
> I don't think it will be a big deal if they disappear.  I think most of
> them are just there because the original HAL had them.
> 
> Maybe one or two functions are waiting on an API in the stack to be useful
> (e.g. antenna stuff), but we can always get these routines back from git
> history if need be.

I see you are doing that work already, so please just tell me if I need
to resubmit my patches.

-- 
Regards,
Pavel Roskin
