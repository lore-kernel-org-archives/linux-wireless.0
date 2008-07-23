Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:59610 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbYGWSDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 14:03:15 -0400
Message-ID: <48877260.7040008@lwfinger.net>
Date: Wed, 23 Jul 2008 13:03:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
 rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>	 <200807221613.34434.herton@mandriva.com.br>	 <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com>	 <200807221940.20009.herton@mandriva.com.br> <4886AA3B.3000406@lwfinger.net>		 <4886C50E.6040304@lwfinger.net> <1216824917.13587.9.camel@johannes.berg>	  <48874F09.7060400@lwfinger.net> <1216830449.13587.17.camel@johannes.berg>
In-Reply-To: <1216830449.13587.17.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> Odd, that looks like it should work. Can you try printing the seqno and
> see if it does increase? Or maybe I messed up something with the
> flags...

It is increasing just as expected, but no connection.

Larry

