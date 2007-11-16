Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53260 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758728AbXKPOVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 09:21:45 -0500
Message-ID: <473DA777.2090203@lwfinger.net> (sfid-20071116_142149_188873_2A0BE9BE)
Date: Fri, 16 Nov 2007 08:21:43 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix compilation errors in ssb
References: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net> <200711161130.46770.mb@bu3sch.de>
In-Reply-To: <200711161130.46770.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Friday 16 November 2007 07:48:23 Larry Finger wrote:
>> Recent changes in ssb sprom handling break compilation. These two patches
>> fix the problem.
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> These two changes should be applied to the everything branch of wireless-2.6
>> ASAP. Sorry about the mixup - I have no idea what happened.
> 
> are your sprom r4 changes already applied? I didn't test that in the b44, yet.

I did a git pull yesterday and the sprom r3 and r4 changes were in wireless-2.6/everything.

Larry
