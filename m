Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange07.timesys.com ([209.114.137.35]:25894 "EHLO
	exchange07.timesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZAETrC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 14:47:02 -0500
Message-ID: <496263BC.5020707@cheek.com> (sfid-20090105_204713_600205_E50DCCC3)
Date: Mon, 5 Jan 2009 14:47:08 -0500
From: Joseph Cheek <joseph@cheek.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] 2.6.27 with compat-wireless-2008-12-31 stops	transmitting
 every 2-3 minutes
References: <495C7640.8060806@cheek.com> <20090105170432.GA6834@tesla> <49624B10.70400@cheek.com> <20090105181250.GD6834@tesla>
In-Reply-To: <20090105181250.GD6834@tesla>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is this page up to date?  I found the latest 802.11n NIC that I could
find for my machine...

http://wireless.kernel.org/en/users/Drivers/ath9k#ProductsintheretailmarketcontainingAtheros11nsolutions

I bought my card after specifically consulting this page.

thanks!

Joseph Cheek

Luis R. Rodriguez wrote:
> Anything communication on the same spectrum affects your 802.11
> connection,
> so using the microwave oven, using bluetooth, or a 2.4 GHz home phone should
> affet your connection. Not sure the freq used by Xbox / PS3 controllers...
> Bluetooth particularly should affect your 802.11 connection and we only recently
> added bluetooth coexistance to help with this but this is only available for
> more modern cards so your card does not have this feature.
>
> If you are using bluetooth then it should affect your connection if using the
> 2.4 GHz spectrum on your wirless AP.
>
>   Luis
>
>   
