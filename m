Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50009 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937AbYAICc7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 21:32:59 -0500
Subject: Re: merge errors on 'everything'
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: bruno randolf <bruno@thinktube.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080109015102.GB3048@tuxdriver.com>
References: <200801091043.02204.bruno@thinktube.com>
	 <20080109015102.GB3048@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 21:32:48 -0500
Message-Id: <1199845968.3697.22.camel@dv> (sfid-20080109_023305_099149_DCF84648)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-01-08 at 20:51 -0500, John W. Linville wrote:
> On Wed, Jan 09, 2008 at 10:43:01AM +0900, bruno randolf wrote:
> > hi!
> > 
> > many times when i do a 'git pull' to update the wireless-2.6 'everything' 
> > branch i run into unexplicable merge errors.
> > 
> > i created the branch with 'git co --track -b everything origin/everything' and 
> > i don't work on this branch so all files are un-modified.
> > 
> > what am i doing wrong?
> 
> You'll need to get a fresh clone of the repository -- sorry.

While it's reassuring to see that I'm not missing some elegant solution,
I think cloning the repository is a major overkill.

"git-reset --hard origin/everything" does the trick for me, while using
much less bandwidth and time.  It even works with StGIT because it
unapplies the patches before pulling and doesn't apply them in case of
conflicts.  I can apply the StGIT patches after "git-reset".

-- 
Regards,
Pavel Roskin
