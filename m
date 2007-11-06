Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:64206 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235AbXKFT3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:29:53 -0500
Message-ID: <4730C0A5.60700@lwfinger.net> (sfid-20071106_192954_992016_63FF4CB6)
Date: Tue, 06 Nov 2007 13:29:41 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC 1 of 6] ssb: Add new SPROM structure while keeping the old
References: <4730bd03.rGmiNlJ18XBoW/Yb%Larry.Finger@lwfinger.net> <200711062022.41248.mb@bu3sch.de>
In-Reply-To: <200711062022.41248.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 06 November 2007 20:14:11 Larry Finger wrote:
>> +	u8 et0phyaddr:5;	/* MII address for enet0 */
>> +	u8 et1phyaddr:5;	/* MII address for enet1 */
> 
> While we are at it, please also get rid of these ugly foo:X bitfields.
> 

Done.

Larry

