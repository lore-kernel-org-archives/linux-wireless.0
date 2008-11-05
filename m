Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50542 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYKEF2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 00:28:11 -0500
To: "Dan Williams" <dcbw@redhat.com>
Cc: Alexey Fisher <bug-track@fisher-privat.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rjw@sisk.pl, kernel-testers@vger.kernel.org
Subject: Re: [PATCH] make assocaittion only if SSID is known.
References: <1225836101-5723-1-git-send-email-bug-track@fisher-privat.net>
	<1225838828.22671.0.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 05 Nov 2008 07:25:51 +0200
In-Reply-To: <1225838828.22671.0.camel@localhost.localdomain> (ext Dan Williams's message of "Tue\, 04 Nov 2008 17\:47\:08 -0500")
Message-ID: <871vxq217k.fsf@nokia.com> (sfid-20081105_062818_661513_7D86A747)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

> On Tue, 2008-11-04 at 23:01 +0100, Alexey Fisher wrote:
>> 'iwconfig eth1 channel 6' would trigger association to _something_,
>> which is wrong. Changing the channel should (and does) trigger
>> reassociation, but only if there is an SSID to associate with!
>
> Heh :)  Need the Signed-off-by: here too though.

And the subject should contain the driver name, for example like this:

[PATCH] ipw2200: associate only when SSID is known

-- 
Kalle Valo
