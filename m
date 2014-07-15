Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51043 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933396AbaGOTpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 15:45:10 -0400
Date: Tue, 15 Jul 2014 15:30:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH][3.16 MAYBE?] b43: don't warn about no 5 GHz support on
 2.4 GHz devices
Message-ID: <20140715193011.GE26012@tuxdriver.com> (sfid-20140715_214907_061642_7E4EED0E)
References: <1404846019-11079-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1404846019-11079-1-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 08, 2014 at 09:00:19PM +0200, Rafał Miłecki wrote:
> This could be a bit confusing to see warning about lacking support for
> 5 GHz band if your device supports 2.4 GHz only.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: even I was quite confused to see this warning on my BCM5357. I
> suspected b43 incorrectly detected my WiFi as 5 GHz capable. I think
> that proposed behavior makes more sense.
> Do you think it's OK/worth to take it for 3.16?

I don't really think it merits prommotion to 3.16.  I am happy to
merge it for -next.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
