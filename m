Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58142
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXCaQkG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 12:40:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: dragoran <drago01@gmail.com>
Subject: Re: mac80211 does not support WPA when used with wext
Date: Sat, 31 Mar 2007 18:39:48 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <460E2B8C.4030002@gmail.com> <460E43D6.1060501@gmail.com> <200703311837.27990.mb@bu3sch.de>
In-Reply-To: <200703311837.27990.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703311839.48379.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 March 2007 18:37, Michael Buesch wrote:
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

Well, except for the WEXT breakage on platforms with 64bit kernel
and 32bit userland. But there WEXT doesn't work with ieee80211, either.

-- 
Greetings Michael.
