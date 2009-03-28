Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46783 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbZC1MgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 08:36:09 -0400
Date: Sat, 28 Mar 2009 09:36:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [GIT PATCH] rfkill updates
Message-ID: <20090328123602.GC7439@khazad-dum.debian.net> (sfid-20090328_133613_664184_C6021412)
References: <1238168651-28891-1-git-send-email-hmh@hmh.eng.br> <1238189590.4452.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238189590.4452.24.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
> Can we drop all this? I'm rewriting the entire rfkill core to better
> support hard/soft kills, and all this code pretty much goes away anyway.

Sure.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
