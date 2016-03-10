Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33441 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbcCJRaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 12:30:23 -0500
Received: by mail-wm0-f47.google.com with SMTP id l68so38182264wml.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 09:30:22 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: New firmware for RT2870
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56E1AF2B.7030206@gmail.com> (sfid-20160310_183026_750279_F76374C6)
Date: Thu, 10 Mar 2016 18:30:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> I downloaded the firmware from b.k.o. It had very little effect on my no-name 
> adapter with ID 148f:3070. It still gets ping losses of 10-15%.

I have tested 0.36 on a 148f:3070 (high quality) device for 4 hours,
and it has worked *flawlessly* .
(Fedora 23 + updates-testing.repo - kernel-4.4.4-301 - wpa_supplicant-2.4-7
AP: Buffalo WZR-HP-G300NH2 running OpenWrt-snapshots-2016-Mar-09 [1])

Last year I have been in touch with Mediatek crew, and they said(12/09/2015):
"According to the engineers comment, the firmware didn't change much
these years, just some bbp register update and led stuff."


[1] Friends don't let friends run stock router firmware.
