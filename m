Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:51750 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756733AbYARUd1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 15:33:27 -0500
Date: Fri, 18 Jan 2008 21:26:12 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Hauke Mehrtens <hauke@hauke-m.de>,
	Andrea Merello <andreamrl@tiscali.it>,
	Michael Wu <flamingice@sourmilk.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 rate control doesn't work
Message-ID: <20080118212612.4e86d1f1@morte> (sfid-20080118_203337_101264_A86DF17D)
In-Reply-To: <479109B7.5030808@hauke-m.de>
References: <477F9890.5050107@hauke-m.de>
	<43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	<47824D25.5090005@hauke-m.de>
	<43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
	<4787F03E.6080605@hauke-m.de>
	<4788D24E.30805@hauke-m.de>
	<20080112162121.2fc2f507@morte>
	<478905B9.3080004@hauke-m.de>
	<20080112202854.2c24ba19@morte>
	<478F8CFF.2060105@hauke-m.de>
	<20080118210452.50c84d13@morte>
	<479109B7.5030808@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[CC'ing rtl8187 maintainers again - please don't strip CC's off]

On Fri, 18 Jan 2008 21:19:03 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> Stefano Brivio wrote:
> > Are you using an 802.11b only access point, or an access point configured
> > to support 802.11b only?
> 
> My Access Point is using 802.11g and 802.11b in mixed mode. With my
> notebook (b43 driver) I am getting a good connection to the Access Point.

Should I assume that this happens with the same kernel setup?

> If the Access Point is configured to support 802.11b only I have no
> problems with the rtl8187 card, because the card doesn't try to set the
> rate above 11M.

Then it looks like for some reason frames sent with rtl8187 using OFDM rates
silently fail, no errors are reported even if they aren't getting ACKed.
Andrea, Michael, any clue?


--
Ciao
Stefano
