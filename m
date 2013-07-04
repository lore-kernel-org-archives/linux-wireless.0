Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:34903 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990Ab3GDITh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 04:19:37 -0400
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out03.msg.oleane.net with ESMTP id r648JZKU027927
	for <linux-wireless@vger.kernel.org>; Thu, 4 Jul 2013 10:19:35 +0200
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>	 <070e01ce762c$24fa5ff0$6eef1fd0$@acksys.fr>	 <00e901ce7886$ae44d360$0ace7a20$@acksys.fr> <1372923998.8235.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372923998.8235.1.camel@jlt4.sipsolutions.net>
Subject: RE: [PATCH V2] vlan priority handling in WMM
Date: Thu, 4 Jul 2013 09:59:04 +0200
Message-ID: <00ea01ce788c$5a2d35f0$0e87a1d0$@acksys.fr> (sfid-20130704_101942_172001_4D31F54B)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry but I have some problems with my mail server, and actually, I have a lot of mail not sent. So I was not sure you received my message.

I waiting the end of merge windows

Cedric

-----Message d'origine-----
De : Johannes Berg [mailto:johannes@sipsolutions.net] 
Envoyé : jeudi 4 juillet 2013 09:47
À : voncken
Cc : linux-wireless@vger.kernel.org
Objet : Re: [PATCH V2] vlan priority handling in WMM

On Thu, 2013-07-04 at 09:18 +0200, voncken wrote:
> If the VLAN tci is set in skb->vlan_tci use the priority field to 
> determine the WMM priority.

Pinging me and resending your patch isn't going to make it more likely that I apply it. We're in the merge window, so naturally patch application is stalled.

johannes


