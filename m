Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:53924 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXJOKJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 06:09:30 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1IhMqY-0001J0-2d
	for linux-wireless@vger.kernel.org; Mon, 15 Oct 2007 10:06:50 +0000
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 10:06:50 +0000
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 10:06:50 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: rt2500pci 2.0.9 not working
Date: Mon, 15 Oct 2007 11:57:19 +0200
Message-ID: <fevdi0$til$1@ger.gmane.org> (sfid-20071015_110934_435679_E0BEA433)
References: <fdqhn4$qab$1@sea.gmane.org> <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com> <1192094159.4770.21.camel@johannes.berg> <200710112005.56101.IvDoorn@gmail.com> <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com> <fent23$9gc$1@sea.gmane.org> <470F89C1.8030406@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> is established, the rate-setting mechanism in rc80211_simple will adjust
> the rate to what it considers the highest value that works.

I get download rates of about 9 Mbit, but iwconfig still says the bit rate
is 1 Mbit, which seems a bit strange.

Marcus


