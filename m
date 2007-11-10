Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:54056
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXKJPZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Nov 2007 10:25:46 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Output message at startup if hardware switch for radio is off
Date: Sat, 10 Nov 2007 16:24:50 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4734e389.AF3t4zZIQw1IryOf%Larry.Finger@lwfinger.net>
In-Reply-To: <4734e389.AF3t4zZIQw1IryOf%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711101624.50808.mb@bu3sch.de> (sfid-20071110_152552_366446_95455463)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 November 2007 23:47:37 Larry Finger wrote:
> Now that the radio is controlled by rfkill, there is a potential
> difficulty in helping a new user get started, as it is unlikely
> that they will have setup rfkill. This patch prints a message if
> the interface is started with the hardware switch off.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch is intended for the everything branch of wireless-2.6.
> 
> Larry

Well... Pressing the rfkill button is the _FIRST_ thing that I would
do, if the device does not work. I'm wondering why people have a problem
with that. On other operating systems it's the very same. On Windows there
is no dmesg.

-- 
Greetings Michael.
