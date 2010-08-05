Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:41207 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361Ab0HEA5a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 20:57:30 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ogom1-0002S4-8h
	for linux-wireless@vger.kernel.org; Thu, 05 Aug 2010 02:57:29 +0200
Received: from 216-31-249-246.static-ip.telepacific.net ([216.31.249.246])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 02:57:29 +0200
Received: from graman by 216-31-249-246.static-ip.telepacific.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 02:57:29 +0200
To: linux-wireless@vger.kernel.org
From: Gopal Raman <graman@arubanetworks.com>
Subject: Re: ath5k : Channel 149 thru 161 not working with compat-wireless-2.6.34.1
Date: Thu, 5 Aug 2010 00:57:21 +0000 (UTC)
Message-ID: <loom.20100805T025322-892@post.gmane.org>
References: <loom.20100805T020816-848@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> 

Gopal Raman <graman@...> writes:

Another piece of information is that when the channel is set to 149, 'cat
/proc/interrupts' hardly increments whereas on channel 36 it goes up
real fast. Also 'iw ph0 info' does show that channels 149 thru 161
in its output.
-gopal

