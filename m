Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60990 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZIDIFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 04:05:34 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MjTnc-0004AU-9Y
	for linux-wireless@vger.kernel.org; Fri, 04 Sep 2009 10:05:36 +0200
Received: from cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com ([82.16.96.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2009 10:05:36 +0200
Received: from jon.fairbairn by cpc1-cmbg9-0-0-cust9.cmbg.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2009 10:05:36 +0200
To: linux-wireless@vger.kernel.org
From: Jon Fairbairn <jon.fairbairn@cl.cam.ac.uk>
Subject: AP: ath5k + hostapd occasionally sulks
Date: Fri, 04 Sep 2009 09:05:02 +0100
Message-ID: <wf8wgvqgnl.fsf@calligramme.charmers>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm running hostapd 0.6.9 and currently compat-wireless-2009-08-22.

This seems to work most of the time, but occasionally (usually days
between occurrences) stops accepting connexions. Usually there's no
indication of this in the logs, but when clients try to associate they
eventually time out.

However, the most recent time this happened was when I was downloading a
large amount of data to one of the clients. I got a lot of

ath5k phy0: no further txbuf available, dropping packet

in the log and then the connexion died and wouldn't come back until I
restarted hostapd (I reloaded ath5k for good measure; I should probably
have tried without doing that...)

I have two questions: 

(1) is that buffer message something that might have been addressed
since 2009-08-22, and

(2) What can I do to track down something that happens this
infrequently? I'm running hostapd with -d, but that doesn't log anything
different when it happens.



-- 
Jón Fairbairn                                 Jon.Fairbairn@cl.cam.ac.uk


