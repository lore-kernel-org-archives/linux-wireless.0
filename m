Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:24630 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZLCLB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 06:01:29 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: question regarding cfg80211 monitor modes
Date: Thu, 3 Dec 2009 12:00:56 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200912031148.46934.holgerschurig@gmail.com> <1259837682.12843.10.camel@johannes.local>
In-Reply-To: <1259837682.12843.10.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912031200.56443.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I'd say don't bother with the flags at all.

Okay, I'll then a mask of 0x07, turning everything on. If someone 
doesn't like beacons, he can still use

  tshark -R "!(wlan.fc.subtype == 8)"



BTW: 
http://wireless.kernel.org/en/users/Documentation/modes#Monitor_mode 
doesn't say anything about the modes.

-- 
http://www.holgerschurig.de
