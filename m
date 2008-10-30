Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47921 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYJ3RbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:31:08 -0400
Date: Thu, 30 Oct 2008 13:29:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Re: Guidelines regarding separate directory
Message-ID: <20081030172919.GA4330@tuxdriver.com> (sfid-20081030_183121_444381_FEB291D5)
References: <4909EA78.3060700@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4909EA78.3060700@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 10:10:16AM -0700, Larry Finger wrote:
> I am planning on adding code to control the LEDs on the RTL8187 devices based on
> the latest vendor driver. From the expected size of the code, I think that
> separate files will be best.
> 
> What number of files in a driver make it advisable to create a separate
> directory? Between the rtl8180 and rtl8187 drivers, there are now 15 files and I
> will be adding at least 2 more. Is this the time to create a rtl818x directory
> under drivers/net/wireless?

Yes.  It should have been done long ago -- I had them all in
drivers/net/wireless due to my own misinterpretation of the policy
in the past.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
