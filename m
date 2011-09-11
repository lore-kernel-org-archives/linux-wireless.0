Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta6.srv.hcvlny.cv.net ([167.206.4.212]:36967 "EHLO
	mta6.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab1IKQXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Sep 2011 12:23:51 -0400
Received: from saf.optonline.net
 (ool-44c01ab5.dyn.optonline.net [68.192.26.181]) by mta6.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-9.20 (built Jul 15 2010))
 with ESMTP id <0LRD00J6885IP610@mta6.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sun, 11 Sep 2011 11:53:50 -0400 (EDT)
Date: Sun, 11 Sep 2011 11:53:42 -0400
From: "Steven A. Falco" <safalco@optonline.net>
Subject: Re: [Question] Realtek USB 0bda:8176 as AP?
In-reply-to: <4E6C304B.6050306@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Steven A. Falco" <sfalco@coincident.com>,
	linux-wireless@vger.kernel.org
Message-id: <4E6CD986.3040104@optonline.net> (sfid-20110911_182355_115337_093B6383)
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <4E6C0AC8.9050805@coincident.com> <4E6C304B.6050306@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2011 11:51 PM, Larry Finger wrote:
> On 09/10/2011 08:11 PM, Steven A. Falco wrote:
>> I am attempting to use a Realtek USB dongle as an access point on
>> a PC running Fedora 15, with hostapd as the user-layer SW.
>>
>> The USB ID is 0bda:8176, which makes this an rtlwifi:rtl8192cu
>> device.
> 
> What kernel are you running? The latest is in wireless-testing, but that will be difficult to clone as long as kernel.org is out of commission. In addition, there are two patches that were sent on 9/3, but have not yet been incorporated due to the k.o problems. They are attached.
> 

I'm using kernel-3.1.0-0.rc3.git0.0.fc16.src.rpm from Fedora 16.
I'll apply the patches you provided and test a bit later today.

	Steve

> I just got a Powermac G4 and I'm fixing the big-endian issues, but that is clearly not your problem.
> 
> Larry
> 

