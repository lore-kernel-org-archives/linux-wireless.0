Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:45868 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZHKVcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 17:32:04 -0400
Received: by rv-out-0506.google.com with SMTP id f6so1418234rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 14:32:05 -0700 (PDT)
Message-ID: <4A81E350.5080105@lwfinger.net>
Date: Tue, 11 Aug 2009 16:32:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: B43: MGMT (TX callback) fail
References: <loom.20090811T163732-716@post.gmane.org> <loom.20090811T175527-147@post.gmane.org> <loom.20090811T204305-105@post.gmane.org>
In-Reply-To: <loom.20090811T204305-105@post.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manuel Schölling wrote:
> 
> Sorry about all the noise.
> I got it working switching to channel 1 (based on this post:
> http://lists.berlios.de/pipermail/bcm43xx-dev/2009-April/008896.html)
> It's for b43 legancy but I'm using 'ordinary' b43...
> 
> Anyway, is it already fixed in SVN version?

What is to fix? The message you posted was from somebody that had a
problem with the Broadcom wl (_CLOSED_ _SOURCE_ _DRIVER_)! We could
not fix that if we wanted to, and we have no interest in touching that
driver.

If you find a bug in b43, and document it, then it will get fixed.

BTW, there is no SVN version. All code versioning is done with git.
The wireless-testing git tree is what most of us use and test.

