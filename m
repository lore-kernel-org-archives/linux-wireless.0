Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39048 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049AbZGFP6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 11:58:06 -0400
Date: Mon, 6 Jul 2009 12:58:05 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill: prep for rfkill API changes
Message-ID: <20090706155805.GD753@khazad-dum.debian.net>
References: <1246798266.4411.1.camel@johannes.local>
 <20090705132422.GA30334@khazad-dum.debian.net>
 <1246801098.4411.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1246801098.4411.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 05 Jul 2009, Johannes Berg wrote:
> On Sun, 2009-07-05 at 10:24 -0300, Henrique de Moraes Holschuh wrote:
> > This is good, but not complete.  Changes to the API that don't change the
> > size (or those which reduces it) are a problem: they are impossible with a
> > schema that detects API version by the size alone.
> 
> Umm, no, we can also add operations as required already.

Yeah, I know.  What we can't do is to change the current ones, or drop them.

> _subtlety_ involved in actually doing a size change, nothing more. A
> real event version is _not_ necessary at all. In fact, I would argue
> that basing _anything_ on the "version" rather than the "feature set" is
> useless.

IMO version can tell you the supported feature set, but one could use a
feature set bitmap as well if one wanted.  Anyway, if you guys deem the
current way good enough, I am fine with it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
