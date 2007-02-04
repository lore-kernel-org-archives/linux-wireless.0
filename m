Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:52426 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752459AbXBDRha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 12:37:30 -0500
Message-ID: <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net>
Date: Sun,  4 Feb 2007 12:30:48 -0500
From: Pavel Roskin <proski@gnu.org>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: SoftMAC vs FullMAC
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
In-Reply-To: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jon Smirl <jonsmirl@gmail.com>:

> Has it been considered to simply treat all wireless hardware as
> SoftMAC and to just ignore the FullMAC capabilities?
[skip]
> Dscape looks to have already started down this path with
> implementations for five vendors. Is the plan to do this for all
> vendors, including Intel and Atheros?

It is the plan for Atheros.  See Dadwifi.

In fact, Atheros chips are not that intelligent to be treated as FullMAC, but
going to d80211 removes many chip specific features.

--
Regards,
Pavel Roskin
