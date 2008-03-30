Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33562 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752650AbYC3Qtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 12:49:49 -0400
Subject: Re: rt2500pci, infinite calls to rt2x00mc_configure_filter
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Bas Hulsken <bhulsken@hotmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1206894742.6450.13.camel@Bas>
References: <1206801246.24689.19.camel@Bas>
	 <loom.20080329T232927-720@post.gmane.org> <1206882945.4973.5.camel@Bas>
	 <200803301527.34583.IvDoorn@gmail.com>  <1206894742.6450.13.camel@Bas>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 18:49:44 +0200
Message-Id: <1206895784.7752.5.camel@localhost> (sfid-20080330_175000_807375_1718AB73)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-03-30 at 18:32 +0200, Bas Hulsken wrote:
> I've made the dumps you've asked for; at least I think so:
> '/debug/ieee80211/phy2/rt2500pci/frame/dump' as mentioned in the rt2wtap
> doc does not exist for me, so I've captured from:
> '/debug/ieee80211/phy1/rt2500pci/queue/dump' is that the new name or
> something?

Yes. I need to update the documentation :-)

Mattias

