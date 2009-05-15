Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([204.127.217.105]:57223 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZEOWRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 18:17:09 -0400
Message-ID: <4A0DE9CC.5050109@lwfinger.net>
Date: Fri, 15 May 2009 17:16:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
References: <49F8C03D.6040909@lwfinger.net> <1241040451.5067.0.camel@johannes.local> <49F8E145.1050708@lwfinger.net> <200905152349.47940.rjw@sisk.pl>
In-Reply-To: <200905152349.47940.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafael J. Wysocki wrote:
>>
>> kernel: phy0: failed to reallocate TX buffer 0, 404, need 0, 0
>> kernel: protocol 0008 is buggy, dev eth1
>>
>> kernel: phy0: failed to reallocate TX buffer 0, 1728, need 0, 18
>>
>> Device eth1 is the b43 wireless device.
> 
> Can you please tell me what the status of this bug is?

I have not had the opportunity to trace this bug.

