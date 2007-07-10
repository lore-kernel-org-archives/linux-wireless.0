Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:59999 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbXGJIUH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 04:20:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1I8Ax0-00069H-9a
	for linux-wireless@vger.kernel.org; Tue, 10 Jul 2007 10:20:02 +0200
Received: from 213.157.13.90 ([213.157.13.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2007 10:20:02 +0200
Received: from genstef by 213.157.13.90 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2007 10:20:02 +0200
To: linux-wireless@vger.kernel.org
From: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: Monitor mode with RTL8187
Date: Tue, 10 Jul 2007 10:07:02 +0200
Message-ID: <f6vep6$n3$1@sea.gmane.org>
References: <59abf66e0707091451p3913ba5enf35edd934840b3cb@mail.gmail.com> <4693176F.6070407@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> ifconfig wlan0 down
> 
> Then after changing the mode, bring it up and set the channel.

why can it not do that automatically when issueing the mode monitor command?

Seems usability has not yet reached wireless configuration - where it is imo
much needed.

-Stefan

