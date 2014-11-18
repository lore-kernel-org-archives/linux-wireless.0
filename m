Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40273 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbaKRFAJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 00:00:09 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XqatZ-0002BO-5X
	for linux-wireless@vger.kernel.org; Tue, 18 Nov 2014 06:00:07 +0100
Received: from 76-14-102-124.rk.wavecable.com ([76.14.102.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2014 06:00:05 +0100
Received: from ptcongdon by 76-14-102-124.rk.wavecable.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 18 Nov 2014 06:00:05 +0100
To: linux-wireless@vger.kernel.org
From: Paul <ptcongdon@ucdavis.edu>
Subject: Error code -149 trying to receive Probe Requests using =?utf-8?b?Tkw4MDIxMV9DTURfUkVHSVNURVJfRlJBTUU=?=
Date: Tue, 18 Nov 2014 04:53:24 +0000 (UTC)
Message-ID: <loom.20141118T054805-587@post.gmane.org> (sfid-20141118_060256_456012_8635C1A6)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to write an linux process that will receive Probe Request 
messages from nl80211 using NL80211_CMD_REGISTER_FRAME.   This process 
will run at the same time hostapd is doing its job.  Is it possible for 
multiple linux processes to receive the same set of Probe Request messages 
this way?   I'm getting an error code -149 after issuing my 
NL80211_CMD_REGISTER_FRAME command. The command is exactly the same 
command that hostapd is issuing.  It looks like -149 implies EALREADY, 
which leads me to believe that only one process can register for these 
frames?  Any suggestions or examples of successfully using 
NL80211_CMD_REGISTER_FRAME in a separate user space program?

Thanks very much,
Paul


