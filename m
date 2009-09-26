Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:7760 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbZIZPdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 11:33:13 -0400
Date: Sat, 26 Sep 2009 16:33:14 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253973831.5122.33.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909261631110.4336@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
  <1253856038.3868.500.camel@johannes.local>  <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
  <1253868214.3868.713.camel@johannes.local>  <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
  <1253970049.5122.31.camel@johannes.local> <1253973831.5122.33.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Sep 2009, Johannes Berg wrote:
> On Sat, 2009-09-26 at 15:00 +0200, Johannes Berg wrote:
> > 
> > I'm downloading a livecd to figure out what might be going wrong.
> 
> It appears that just uses
> 	test -d /sys/class/net/wlan0/wireless
> 
> but that should be ok, unless that's actually a link now for some reason
> -- can you verify what happens there? And double-check you have
> CONFIG_WIRELESS_EXT_SYSFS please, the config you sent me did have it
> tho.

I do have CONFIG_WIRELESS_EXT_SYSFS=y,
and I do have /sys/class/net/wlan0/ containing various things,
but I don't have any /sys/class/net/wlan0/wireless with recent kernels.

Hugh
