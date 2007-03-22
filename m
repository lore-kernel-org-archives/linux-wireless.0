Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sccrmhc15.comcast.net ([63.240.77.85]:60698 "EHLO
	sccrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbXCVAoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 20:44:19 -0400
Message-ID: <4601D14B.5090001@gentoo.org>
Date: Wed, 21 Mar 2007 20:43:55 -0400
From: Joseph Jezak <josejx@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <larry.finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Change radio_init2050 to match specs
References: <460048f1.Sz+VinhM/N8KG294%Larry.Finger@lwfinger.net> <200703211501.48178.mb@bu3sch.de> <46014F75.7080609@lwfinger.net> <200703211717.53055.mb@bu3sch.de>
In-Reply-To: <200703211717.53055.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 >>From my understanding current code is correct.
> But I see that one could interpret the spec in your way as well.
> Joseph?

If the External LNA value, as read from the table, is non-zero, OR
that value with 0x8000 (which I think is the "enable the External
LNA flag).

I've updated the specs to reflect this.

-Joe


