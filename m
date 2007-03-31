Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbXCaRyZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 13:54:25 -0400
Subject: Re: mac80211 does not support WPA when used with wext
From: Dan Williams <dcbw@redhat.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: dragoran <drago01@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200703311837.27990.mb@bu3sch.de>
References: <460E2B8C.4030002@gmail.com>
	 <1175335211.23438.45.camel@johannes.berg> <460E43D6.1060501@gmail.com>
	 <200703311837.27990.mb@bu3sch.de>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 13:57:55 -0400
Message-Id: <1175363875.9349.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-03-31 at 18:37 +0200, Michael Buesch wrote:
> On Saturday 31 March 2007 13:19, dragoran wrote:
> > Johannes Berg wrote:
> > > On Sat, 2007-03-31 at 11:36 +0200, dragoran wrote:
> > >   
> > >> Hello
> > >> While testing the iwlwifi driver I noticed that the mac80211 does 
> > >> provide a wext interface but does not support wpa with it.
> > >>     
> > >
> > > You must have done something wrong, it works well.
> > >
> > >   
> > same also happens with the rt2x00 drivers....
> > it seems that I am not doing something wrong but that you are using a 
> > ieee80211 based driver....
> 
> I think you can trust Johannes, the author of the mac80211 configuratrion
> interface, in this matter. ;)
> mac80211 _does_ work with WPA. For sure. 100%.
> You are doing something wrong.

No, he's not, see my previous post.  mac80211 doesn't use the right
WE-18 and later IWEVGENIE event to report IEs in scan results.  Like
every other in-kernel driver/stack out there besides mac80211.

Dan


