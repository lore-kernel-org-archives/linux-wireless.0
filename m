Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43500 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1LIEUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 23:20:20 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RYrwY-0002UH-Jx
	for linux-wireless@vger.kernel.org; Fri, 09 Dec 2011 05:20:18 +0100
Received: from 152-pra-26.acn.waw.pl ([85.222.113.152])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 05:20:18 +0100
Received: from harasimczuk by 152-pra-26.acn.waw.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 05:20:18 +0100
To: linux-wireless@vger.kernel.org
From: Marcin <harasimczuk@gmail.com>
Subject: Question: Receiving Probe Request frames via =?utf-8?b?Tkw4MDIxMV9DTURfRlJBTUU=?= event
Date: Fri, 9 Dec 2011 04:14:41 +0000 (UTC)
Message-ID: <loom.20111209T045811-823@post.gmane.org> (sfid-20111209_052023_092983_CB24E6BA)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

My problem:

I am listening to nl80211 events the same way it is done in project iw. Before
listening to events on a nl80211 socket I register it for receiving Probe
Request via NL80211_CMD_REGISTER_FRAME ( I checked wpa_supplicant to do it
correctly ). 

My socket does not seem to receive any NL80211_CMD_FRAME events.

Question:

What interface do I have to send my NL80211_CMD_REGISTER_FRAME message to
receive chosen frames. Is the event listening method used in project iw (file
"event.c") enough to receive NL80211_CMD_FRAME events, or do I have to do
something else (something like event loop from wpa_supplicant)? 

Thank You very much.
 

