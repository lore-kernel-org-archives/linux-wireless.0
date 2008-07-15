Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:17225 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780AbYGOQZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 12:25:11 -0400
Date: Tue, 15 Jul 2008 09:24:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-07-14
Message-Id: <20080715092431.d288d0e8.randy.dunlap@oracle.com> (sfid-20080715_182532_675125_B91A7A5F)
In-Reply-To: <20080715134849.GA24361@tuxdriver.com>
References: <20080714192302.GA2541@tuxdriver.com>
	<20080714132918.30a1794f.randy.dunlap@oracle.com>
	<20080715134849.GA24361@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 Jul 2008 09:48:49 -0400 John W. Linville wrote:

> On Mon, Jul 14, 2008 at 01:29:18PM -0700, Randy Dunlap wrote:
> > On Mon, 14 Jul 2008 15:23:02 -0400 John W. Linville wrote:
> > 
> > > Dave,
> > > 
> > > Here is one last(?) round of miscellaneous patches I hope to get into
> > > 2.6.27.  There are mostly driver updates, including a sizable iwlwifi
> > > set of changes.
> > > 
> > > Please let me know if there are problems!
> > 
> > Hi,
> > Dare I ask what happened to the mac80211 kernel-doc patch?
> > 
> > Thanks,
> > ~Randy
> 
> commit 6ef307bc561911c8cdda98ef3896b5982b602a43
> Author: Randy Dunlap <randy.dunlap@oracle.com>
> Date:   Thu Jul 3 13:52:18 2008 -0700
> 
>     mac80211: fix lots of kernel-doc
>     
>     Fix more than 50 kernel-doc warnings in ieee80211/mac80211 kernel-doc notati
>     Fix a few typos also.
>     
>     Note: Some fields are marked as TBD and need to have their description
>     corrected.
>     
>     Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>


Yes, that's in the wireless-next-2.6 git tree:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=6ef307bc561911c8cdda98ef3896b5982b602a43

and this was a pull request, possibly even the last(?) pull, for wireless-next-2.6
for 2.6.27, according to the email intro.  So please tell me what I can
expect for this mac80211 kernel-doc patch.  Thanks.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
