Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39052 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYL1NNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Dec 2008 08:13:45 -0500
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v5 3/3] mac80211: implement dynamic power save
References: <20081218211532.6842.88104.stgit@tikku>
	<20081218211712.6842.98402.stgit@tikku>
	<20081224132432.GA27658@srcf.ucam.org> <87wsdkmp54.fsf@nokia.com>
	<20081228130650.GA9083@srcf.ucam.org>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 28 Dec 2008 15:13:32 +0200
In-Reply-To: <20081228130650.GA9083@srcf.ucam.org> (ext Matthew Garrett's message of "Sun\, 28 Dec 2008 13\:06\:50 +0000")
Message-ID: <87sko8mohv.fsf@nokia.com> (sfid-20081228_141356_561169_85549E8E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthew Garrett <mjg59@srcf.ucam.org> writes:

> On Sun, Dec 28, 2008 at 02:59:35PM +0200, Kalle Valo wrote:
>> Matthew Garrett <mjg59@srcf.ucam.org> writes:
>> 
>> > Are we able to estimate the worst-case latency that will be introduced 
>> > by this? If so, it would be helpful to tie it into the pm_qos framework.
>> 
>> I'm not familiar with pm_qos framework, unfortunately, but there's
>> some work to do still to get mac80211 client power save implemention
>> into shape and I would like get the basics implemented first. After
>> that is done, we could start looking at the pm_qos framework and see
>> if it makes sense to use it.
>
> It allows userspace applications to register their latency requirements. 
> There's a notifier chain that then allows drivers (or subsystems) to be 
> notified of the current requirements, the idea being that they can then 
> limit their deepest power saving mode to one that still satisfies the 
> userspace constraints.

Do these constrainsts also include network latency? Do you have any
suggestions for bedtime reading? :)

-- 
Kalle Valo
