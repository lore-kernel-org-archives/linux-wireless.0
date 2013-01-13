Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13265 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3AMHez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 02:34:55 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Julian Calaby <julian.calaby@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Q: how to update platform power state for the network driver
Date: Sun, 13 Jan 2013 09:34:51 +0200
Message-ID: <2377809.kfu5Ooh83J@lx-vladimir> (sfid-20130113_083501_658717_C3364F6A)
In-Reply-To: <CAGRGNgVUq=8H-r=tA3W5ojyfWPfPt8YHB2zDVpK5EWeF-=5unw@mail.gmail.com>
References: <6929081.7c7blFVDp4@lx-vladimir> <1363680.r8KF83dygC@lx-vladimir> <CAGRGNgVUq=8H-r=tA3W5ojyfWPfPt8YHB2zDVpK5EWeF-=5unw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 11, 2013 11:45:43 AM Julian Calaby wrote:
> > #include <linux/power_supply.h>
> > int power_supply_is_system_supplied(void);
> One minor point: you might want to add the ability to override this,
> even if it's only through debugfs so that people testing the code, or
> with unusual requirements can set this how they want / need it.

Sure, thanks for input
