Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm20-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.165]:35475 "HELO
	nm20-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756143Ab1E2SkY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 14:40:24 -0400
Message-ID: <345324.53571.qm@web161601.mail.bf1.yahoo.com> (sfid-20110529_204027_845239_7CADF577)
Date: Sun, 29 May 2011 11:40:23 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: AP mode - usb wlan interface: Sagem XG-76NA 802.11bg
To: linux-wireless@vger.kernel.org, mafeuser@gmail.com
In-Reply-To: <umt4k4d932ey.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

Your device has ZyDAS zd1211b chip which is covered by the zd1211rw driver. Recently AP support has been implemented for this module. You'll likely need compat-wireless to enable it on your system.

Walter

> Date: Sunday, May 29, 2011, 7:19 PM
> Hallo group members.
> 
> I wonder if I can put it to AP (master mode) or in other
> words, does
> AP/master mode have to be supported by hardware or is it
> only matter of
> software(driver)?
> 
> best redards,
> Paul
> --

> 
