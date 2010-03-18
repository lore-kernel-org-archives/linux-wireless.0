Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:61037 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0CRVKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 17:10:23 -0400
Received: by fg-out-1718.google.com with SMTP id l26so2833044fgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 14:10:22 -0700 (PDT)
Message-ID: <4BA296BA.7000502@lwfinger.net>
Date: Thu, 18 Mar 2010 16:10:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
References: <4BA266FB.1080507@lwfinger.net> <1268945580.4005.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1268945580.4005.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2010 03:53 PM, Johannes Berg wrote:
> On Thu, 2010-03-18 at 12:46 -0500, Larry Finger wrote:
>> Michael,
>>
>> I'm switching this discussion from the kernel Bugzilla to the lists.
>>
>> As you know, but I'm restating for anyone that has not read our previous
>> discussions, the b43 driver needs to be changed to handle some of the newer
>> devices do not have an on-board SPROM. It would be trivial to incorporate the
>> data except for the need to have a unique, reproducible MAC.
> 
> Where does the data usually come from in these devices?

It comes from the SPROM, which is missing in the devices in question. Broadcrap
wanted to save a few pennies.

Larry
