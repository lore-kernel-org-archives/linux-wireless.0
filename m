Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:19748 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZBVGjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 01:39:53 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1276374fkf.5
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2009 22:39:51 -0800 (PST)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
References: <49A01922.1090106@lwfinger.net>
	<1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Feb 2009 08:39:49 +0200
In-Reply-To: <49A05E35.70904@lwfinger.net> (Larry Finger's message of "Sat\, 21 Feb 2009 14\:04\:05 -0600")
Message-ID: <8763j33rgq.fsf@litku.valot.fi> (sfid-20090222_074010_307862_EFC96D26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> I know how it works with drivers that implement their own ioctl
> calls for the WEXT interface; however, the 3 that I mentioned all
> use mac80211 and get their WEXT support through cfg80211.

Yes, something is wrong now. I noticed the same problem (/70 in signal
strength) when I was implementing rssi support for at76c50x-usb.

-- 
Kalle Valo
