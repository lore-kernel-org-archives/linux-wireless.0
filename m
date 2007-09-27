Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52654
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbXI0WgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 18:36:22 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43: RF-kill support
Date: Fri, 28 Sep 2007 00:33:35 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200709272135.35686.mb@bu3sch.de> <200709272303.57040.mb@bu3sch.de> <46FC2BE9.2050705@lwfinger.net>
In-Reply-To: <46FC2BE9.2050705@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200709280033.35765.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 September 2007 00:17:13 Larry Finger wrote:
> Michael Buesch wrote:
> > 
> > Yeah, sure. But it's not useless. The other functionality is still available.
> > I'll fix that. But in a seperate patch. No need to delay this one because
> > of this (IMO) minor issue.
> > 
> 
> How long will the delay be? If relatively short, I'll wait for the final one before submitting the
> port to b43legacy.

One or two days, maybe.
I'm currently debugging another important bug.
And I guess I'll have to sleep in an hour or two, too. :)

The rfkill fix will be incremental based on this one, then.

-- 
Greetings Michael.
