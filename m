Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47851 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941AbZC3NXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 09:23:49 -0400
Date: Mon, 30 Mar 2009 10:23:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rfkill-input madness
Message-ID: <20090330132344.GA11934@khazad-dum.debian.net> (sfid-20090330_152351_649802_6B0239EC)
References: <1238159196.4452.1.camel@johannes.local> <20090327143007.GA24288@khazad-dum.debian.net> <1238188237.4452.17.camel@johannes.local> <20090328005214.GA7439@khazad-dum.debian.net> <1238262651.4217.21.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238262651.4217.21.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Mar 2009, Johannes Berg wrote:
> Ok so you want to add "global" states mostly -- that's fine, but not all
> that useful since userspace cannot really claim globally. I also don't
> see a point -- if userspace wanted to do global stuff it might just as
> well do nothing.

The point of doing global stuff is to do rfkill-input in userspace, the way
userspace might want to do it.

Without the global state being exposed, userspace really can't do anything
properly, and rfkill-input is needed for any semblance of good rfkill input
event handling.

I can't say I strongly want it, since I am happy enough with rfkill-input,
though.  But the API to userspace _is_ incomplete if the global states and
global functionality are not exposed.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
