Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:21265 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932727AbXLMVQA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 16:16:00 -0500
Received: from cerberus.arnhem.chello.nl ([213.93.131.145])
          by viefep33-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20071213211543.TKBI29211.viefep33-int.chello.at@cerberus.arnhem.chello.nl>
          for <linux-wireless@vger.kernel.org>;
          Thu, 13 Dec 2007 22:15:43 +0100
Received: from [192.168.2.3]
	by cerberus.arnhem.chello.nl with esmtp (Exim 4.63)
	(envelope-from <bjd@jooz.net>)
	id 1J2vPC-0006lo-Vx
	for linux-wireless@vger.kernel.org; Thu, 13 Dec 2007 22:15:42 +0100
Message-ID: <4761A108.2080005@jooz.net> (sfid-20071213_211619_809148_3DC1C4B0)
Date: Thu, 13 Dec 2007 22:15:52 +0100
From: Bjorge Dijkstra <bjd@jooz.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: status wireless extensions API for new drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

I have been working on adding support for RNDIS based USB wireless 
devices[1]. Recently I've been getting some help from another developer 
and the state of the driver has improved quite a bit. So we are thinking
about getting it into the mainline kernel.
We have used the Wireless Extensions API, but I get the impression that
things are moving towards the cfg/nl80211 API's. Is it still acceptable
for new drivers trying to get into mainline to use WEXT, or should we
switch to the new API's?

regards,
Bjorge

[1]. http:/www.jooz.net/rndis

