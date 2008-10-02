Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:7443 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYJBVZP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 17:25:15 -0400
Received: by ey-out-2122.google.com with SMTP id 6so441998eyi.37
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 14:25:14 -0700 (PDT)
Message-ID: <48E53C1F.4040909@gmail.com> (sfid-20081002_232521_659419_8E9AE13A)
Date: Thu, 02 Oct 2008 22:24:47 +0100
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: avoid "Wireless Event too big" message for
 assoc response
References: <1222890302-32486-1-git-send-email-linville@linville-t61.local>
In-Reply-To: <1222890302-32486-1-git-send-email-linville@linville-t61.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> An attempt was made by Jouni Malinen to correct this issue by
> converting to use IWEVASSOCREQIE and IWEVASSOCRESPIE messages instead
> ("mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM").  Unfortunately,
> that caused a problem due to 32-/64-bit interactions on some systems and
> was reverted after the 'userland ABI' rule was invoked.

I was unaware of this, and used IWEVASSOCREQIE and IWEVASSOCRESPIE in the
orinoco wpa updates since the events were available in linux/wireless.h.

Should I post a patch to use IWEVCUSTOM instead?


Thanks,

Dave.
