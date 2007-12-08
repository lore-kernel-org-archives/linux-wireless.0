Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:41803 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXLHUgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 15:36:52 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John H." <mistamaila@gmail.com>
Subject: Re: b43 continues to have issue with APs at times
Date: Sat, 8 Dec 2007 21:35:11 +0100
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com>
In-Reply-To: <5b9417770712081222y4f0ab1va51910faf16fb068@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712082135.11685.mb@bu3sch.de> (sfid-20071208_203656_434019_C2DB24B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 December 2007 21:22:37 John H. wrote:
> I have this problem at two different locations with two different
> access points.  2.6.23.1 kernel, and sometimes until I actually power
> down the AP and restart it, wpa_supplicant and such just times out on
> the AP.
> 
> Any ideas?
> 
> 

I think that's rather a mac80211 or supplicant issue.
I think roaming should handle this.
Do you see this with other drivers, too?

-- 
Greetings Michael.
