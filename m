Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46800 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3KLI5t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 03:57:49 -0500
From: Kalle Valo <kvalo@adurom.com>
To: shankar swaminathan <shankswa@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [mac80211] hooking all 802.11 packets to user space without conversion
References: <CADNhdGHGnHDYdum79cY89kV4LtpiGugMc84Mc_4bNmCuOWrn5g@mail.gmail.com>
	<87d2m6rqut.fsf@purkki.adurom.net>
	<CADNhdGEJJ3vjtX+tJAGs78-tGZgS0ivqvXJPGqzaV9mWFAY=dQ@mail.gmail.com>
Date: Tue, 12 Nov 2013 10:57:48 +0200
In-Reply-To: <CADNhdGEJJ3vjtX+tJAGs78-tGZgS0ivqvXJPGqzaV9mWFAY=dQ@mail.gmail.com>
	(shankar swaminathan's message of "Tue, 12 Nov 2013 13:55:03 +0530")
Message-ID: <874n7iro8j.fsf@purkki.adurom.net> (sfid-20131112_095752_503618_2206233E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

shankar swaminathan <shankswa@gmail.com> writes:

> No. I am trying to build an AP. Hence, the interface is in AP mode.
> Can an interface be put in both AP and Monitor so that i just have one
> interface which i can use to get packets in user space in 802.11
> format?

With mac80211 you can add a second monitor mode interface:

http://wireless.kernel.org/en/users/Documentation/modes#Monitor_.28MON.29_mode

Never tried that myself, though.

-- 
Kalle Valo
