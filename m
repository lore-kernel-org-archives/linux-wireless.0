Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55065 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZHKUpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:45:09 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MayDS-0000ju-Gs
	for linux-wireless@vger.kernel.org; Tue, 11 Aug 2009 20:45:06 +0000
Received: from i577B7714.versanet.de ([87.123.119.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 20:45:06 +0000
Received: from manuel.schoelling by i577B7714.versanet.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 20:45:06 +0000
To: linux-wireless@vger.kernel.org
From: Manuel =?utf-8?b?U2Now7ZsbGluZw==?= <manuel.schoelling@gmx.de>
Subject: Re: B43: MGMT (TX callback) fail
Date: Tue, 11 Aug 2009 20:44:57 +0000 (UTC)
Message-ID: <loom.20090811T204305-105@post.gmane.org>
References: <loom.20090811T163732-716@post.gmane.org> <loom.20090811T175527-147@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manuel Schölling <manuel.schoelling@...> writes:

> 
> Sorry, I forgot to tell you that the client machine does not associate with the
> hostapd machine (but it does with other access points).
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@...
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Sorry about all the noise.
I got it working switching to channel 1 (based on this post:
http://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008896.html)
It's for b43 legancy but I'm using 'ordinary' b43...

Anyway, is it already fixed in SVN version?


