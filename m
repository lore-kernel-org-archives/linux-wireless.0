Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33969 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0DLGjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 02:39:40 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: Re: [ath9k-devel] ath9k/mac80211 and 802.11n in IBSS mode
Date: Mon, 12 Apr 2010 08:40:10 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Joerg Pommnitz <pommnitz@yahoo.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
References: <382964.83589.qm@web51407.mail.re2.yahoo.com> <1270822655.3870.21.camel@jlt3.sipsolutions.net> <4BBF902B.7040504@free.fr>
In-Reply-To: <4BBF902B.7040504@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004120840.10990.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Exactly :-). I need to dig into iw source code and understand a bit of
> nl80211 before...

It's not that difficult: use "git log" to look after a patch that added 
something interesting to iw as well. The "git show" that patch. Now you'll 
find out which places to patch.

Adding nl80211-stuff to the kernel involves much dumb boilerplate!


-- 
http://www.holgerschurig.de
