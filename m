Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44616 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbZJBHK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 03:10:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: Linux-2.6.32-rc1/2] wext refactor needs wpasupplicant 0.7.0+?
Date: Fri, 2 Oct 2009 09:10:47 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com> <1254426421.3959.29.camel@johannes.local> <2d0a357f0910011344u4306ecf6ha11410b0f5ed62e3@mail.gmail.com>
In-Reply-To: <2d0a357f0910011344u4306ecf6ha11410b0f5ed62e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910020910.47068.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In both logs you have

1254429476.088527: ctrl_iface bind(PF_UNIX) failed: Address already in use
1254429476.088543: ctrl_iface exists and seems to be in use - cannot override it
1254429476.088548: Delete '/var/run/wpa_supplicant/wlan0' manually if it is not used anymore

are you sure that no other wpa_supplicant did
run when you made the logs?

If yes, then just remove the file and re-run wpa_supplicant.
Be sure to run it as "root".

-- 
http://www.holgerschurig.de
