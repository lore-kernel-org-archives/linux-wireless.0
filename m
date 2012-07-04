Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ivanich.tenet.odessa.ua ([85.238.100.22]:58493 "EHLO
	ivanich.org.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab2GDODY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 10:03:24 -0400
From: Ivan Ivanich <ivanich@ivanich.org.ua>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Regression in the latest wireless-testing
Date: Wed, 04 Jul 2012 17:03:18 +0300
Message-ID: <5047203.BPTB5vMy8b@ivanich.org.ua> (sfid-20120704_160328_127012_48DE70BD)
In-Reply-To: <1341401467.12432.8.camel@jlt3.sipsolutions.net>
References: <1957616.7uPhIQSMg3@ivanich> <1341401467.12432.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Среда, 04-июл-2012 13:31:07 Johannes Berg wrote:
> On Wed, 2012-07-04 at 12:15 +0300, Ivanich wrote:
> > When trying to stop or restart hostapd it says that it could't be stoped
> > and it isn't possible to kill hostapd process, it running with -Ds
> > status, also it causes problems with all network interfaces, for example
> > ifconfig command froze, and can't even reboot without SysRq.
> > Tried clean 3.5.0-rc5-git - it works correctly. I'm using rtl8192ce in AP
> > mode.
> 
> Here's a fix I think:
> 
> http://p.sipsolutions.net/8a1b875a431e72a0.txt
> 
> johannes
Tnak you, tested it and it works now.
