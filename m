Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:57039 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbYG2Dkb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 23:40:31 -0400
Message-ID: <488E912A.8000202@lwfinger.net> (sfid-20080729_054035_177044_B40E9C9A)
Date: Mon, 28 Jul 2008 22:40:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
 rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com> <488E8B68.6000004@lwfinger.net> <200807290029.09114.herton@mandriva.com.br>
In-Reply-To: <200807290029.09114.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> 
> You mean that you couldn't reproduce the bug, ie. with the steps I gave you 
> still could connect and scan for wireless networks? I ask because the failure 
> is the actual bug, for example if you place let's say a sleep for 5 seconds 
> between '... essid any' and '... power on' it doesn't fail.
> 
> The bug is that with that sequence, any attemps to associate or scan fail, 
> where it shouldn't, at least it's what is expected.

I'll try again, but I couldn't make a connection at all using anything other 
than NetworkManager.

Larry

