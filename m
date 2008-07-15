Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4131 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbYGORIn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 13:08:43 -0400
Date: Tue, 15 Jul 2008 12:38:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-07-14
Message-ID: <20080715163858.GA557@tuxdriver.com> (sfid-20080715_190851_694984_534FA8CF)
References: <20080714192302.GA2541@tuxdriver.com> <20080714132918.30a1794f.randy.dunlap@oracle.com> <20080715134849.GA24361@tuxdriver.com> <20080715092431.d288d0e8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080715092431.d288d0e8.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 09:24:31AM -0700, Randy Dunlap wrote:
> On Tue, 15 Jul 2008 09:48:49 -0400 John W. Linville wrote:

> > commit 6ef307bc561911c8cdda98ef3896b5982b602a43
> > Author: Randy Dunlap <randy.dunlap@oracle.com>
> > Date:   Thu Jul 3 13:52:18 2008 -0700
> > 
> >     mac80211: fix lots of kernel-doc
> >     
> >     Fix more than 50 kernel-doc warnings in ieee80211/mac80211 kernel-doc notati
> >     Fix a few typos also.
> >     
> >     Note: Some fields are marked as TBD and need to have their description
> >     corrected.
> >     
> >     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> >     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> 
> Yes, that's in the wireless-next-2.6 git tree:
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=6ef307bc561911c8cdda98ef3896b5982b602a43
> 
> and this was a pull request, possibly even the last(?) pull, for wireless-next-2.6
> for 2.6.27, according to the email intro.  So please tell me what I can
> expect for this mac80211 kernel-doc patch.  Thanks.

We spoke off-line, but just for the public record that commit was
already pulled into net-next-2.6.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
