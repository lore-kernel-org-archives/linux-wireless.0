Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3LPMg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:36:59 -0500
Message-ID: <1387197416.4665.15.camel@jlt4.sipsolutions.net> (sfid-20131216_133702_514978_251C4386)
Subject: Re: [BUG] P2P setup timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 16 Dec 2013 13:36:56 +0100
In-Reply-To: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com> (sfid-20131206_111836_809074_6F087586)
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
	 (sfid-20131206_111836_809074_6F087586)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-12-06 at 11:18 +0100, David Herrmann wrote:
> Hi
> 
> I am currently working on user-space helpers for P2P setup as part of
> an Open-Source Miracast implementation (openwfd). I can set up a
> P2P-group with my Android test-device just fine, however, it only
> works if initiated by the GNU/Linux host. Once I initiate the
> p2p-connect from the Android device, it creates a group and sends me a
> p2p-invitation which I am unable to accept.
> 
> I am running wpa_supplicant-git from today (but also tried older
> versions), ath9k-htc from linus-git (3.13-rc2) and the relevant log
> files are appended.

Can you check in a sniffer what the frame bitrates are that go out? This
seems suspicious:

nl80211: Set TX rates failed: ret=-100 (Network is down)

johannes

