Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f30.google.com ([209.85.219.30]:43462 "EHLO
	mail-ew0-f30.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZATWW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:22:27 -0500
Received: by ewy11 with SMTP id 11so27986ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 14:22:25 -0800 (PST)
Message-ID: <49763FA5.7040101@gmail.com> (sfid-20090120_232232_042860_6ABC8B95)
Date: Tue, 20 Jan 2009 22:18:29 +0100
From: Artur Skawina <art.08.09@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Artur Skawina <art.08.09@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
References: <494698AF.4020204@gmail.com> <200901200032.42202.chunkeey@web.de> <497631A8.9030903@gmail.com> <200901202150.17233.chunkeey@web.de>
In-Reply-To: <200901202150.17233.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> 
> So, p54usb first generation needs the ZERO_PACKET flag as well?
> (e.g a patch like the attached p54usb-net2280-zeropacket.diff ?)

yes, the client would often not even associate w/o that flag in the
int urb.

artur
