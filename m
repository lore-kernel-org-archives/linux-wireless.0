Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:44539 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbYDCQwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 12:52:51 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JhSgE-0002v8-Kl
	for <linux-wireless@vger.kernel.org>; Thu, 03 Apr 2008 17:52:50 +0100
Message-ID: <47F50B62.6030302@fenrir.org.uk> (sfid-20080403_175254_622546_D22DEB80)
Date: Thu, 03 Apr 2008 17:52:50 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [REGRESSION] BCM4306 cannot associate with any version of b43
 driver
References: <200804031115.52596.ace@staticwave.ca>
In-Reply-To: <200804031115.52596.ace@staticwave.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabriel A. Devenyi wrote:
> I feel I have to escalate this regression to the mailing lists because I've had 
> no response on the kernel bugzilla from quite some time now.
> 
> With the release of the b43 driver, my card can no longer associate with its AP. 
> I've been testing with 2.6.24 and the wireless-git tree hoping that someone 
> would fix it, but I've had no requests for testing and no response.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9987
> 
> What else do I need to do to get someone to help me? More debugging information? 
> Please ask me to do something, I'm trying to be an active participant in the 
> process...
> 

Did you notice the old firmware message in the dmesg output you provided?

Have you tried the version 4 firmware?

-- 

Brian

