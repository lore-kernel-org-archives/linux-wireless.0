Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:63250 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbXKSQ0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 11:26:08 -0500
Message-ID: <4741B91D.6010103@lwfinger.net> (sfid-20071119_162611_001257_44EEDA46)
Date: Mon, 19 Nov 2007 10:26:05 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove ieee80211softmac
References: <20071119160626.ED6F19D4B5A@zog.reactivated.net>
In-Reply-To: <20071119160626.ED6F19D4B5A@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:
> With the port of zd1211rw and the removal of bcm43xx, there are no
> remaining softmac users. Remove it.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>
> ---

I got a little too carried away with the emotion. I agree with the removal of SoftMAC, but bcm43xx
must also be removed as well.

Larry

