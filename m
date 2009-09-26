Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:13957 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbZIZPbG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 11:31:06 -0400
Date: Sat, 26 Sep 2009 16:31:06 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253970049.5122.31.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909261625050.4336@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
  <1253856038.3868.500.camel@johannes.local>  <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
  <1253868214.3868.713.camel@johannes.local>  <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
 <1253970049.5122.31.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Sep 2009, Johannes Berg wrote:
> On Fri, 2009-09-25 at 15:15 +0100, Hugh Dickins wrote:
> > 
> > a9a11622c5c742c115fad371c0397ae86dd3bb67 is first bad commit
> > commit a9a11622c5c742c115fad371c0397ae86dd3bb67
> > Author: Johannes Berg <johannes@sipsolutions.net>
> > Date:   Mon Jul 27 12:01:53 2009 +0200
> > 
> >     cfg80211: self-contained wext handling where possible
> 
> Heh, fun.
> 
> Well the problem appears to be that wpa_supplicant isn't getting started
> by your distro any more. Unfortunately I'm not familiar with opensuse.
> It seems it thinks the device isn't wireless but wired, since it starts
> ifplugd. OTOH maybe it wants ifplugd for wireless too? It's possible in
> theory.

No, ifplugd was my choice: IIRC, at some stage of installation you're
given a choice between traditional ifplugd and super new NetworkManager:
my choice has been ifplugd (after being somehow burnt by NetworkManager
once in the past).

> 
> I'm downloading a livecd to figure out what might be going wrong.

Thanks a lot for going to this trouble - though I do realize it's not
all just for me!  My guess is the LiveCD will favour NetworkManager
(if that turns out to make any difference).

> 
> Can you try running wpa_supplicant manually to make sure it's a problem
> in the distro/kernel interaction and not in wpa_supplicant/kernel?

Good idea: I just tried that, and things indeed then work fine.

Hugh
