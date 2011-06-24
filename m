Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58724 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab1FXQDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 12:03:43 -0400
Received: by fxm17 with SMTP id 17so1966268fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 09:03:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: AW: Configuring the multicast data rate with iw/nl80211
Date: Fri, 24 Jun 2011 18:04:48 +0200
Cc: linux-wireless@vger.kernel.org
References: <loom.20110624T123237-71@post.gmane.org> <201106241307.44609.chunkeey@googlemail.com> <1308918895.17410.YahooMailRC@web161205.mail.bf1.yahoo.com>
In-Reply-To: <1308918895.17410.YahooMailRC@web161205.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201106241804.49749.chunkeey@googlemail.com> (sfid-20110624_180347_090563_298B094B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 24 June 2011 14:34:55 Joerg Pommnitz wrote:
> >As an alternative, It's worth a try to look into multicast-to-unicast proxies
> >such as http://sourceforge.net/projects/udpxy/ .
> 
> But then you duplicate the multicast traffic for every STA, no?
Not every STA, only those which subscribed to udpxy at the time.

But there's more, I found it very difficult to "fine-tune" the multicast
setup properly, since there's no automatic feedback for
multicast link quality. Either the rate I picked was too low, or the
signal was too weak, in both cases the video stream as pretty
pretty poor at best.

So I went with the proxy, which as it turns out is a much better
option once you go for 11n. However, the decision is truly yours :D
