Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:42695 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbYCBMZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 07:25:07 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54: fix EEPROM structure endianness
Date: Sun, 2 Mar 2008 13:24:50 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1204289793.3938.20.camel@johannes.berg>
In-Reply-To: <1204289793.3938.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200803021324.51010.florian.fainelli@telecomint.eu> (sfid-20080302_122512_369218_3C0E8F85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Le vendredi 29 f=E9vrier 2008, Johannes Berg a =E9crit=A0:
> ---
> Does anybody have a p54 card and big endian hardware to test it on? I=
'm
> fairly sure this is a correct change but if it currently works on big
> endian the change would be bad (and I'd be rather surprised.)
>

This patch fixes the eeprom fields reading errors that I mentionned on =
the=20
list : http://article.gmane.org/gmane.linux.kernel.wireless.general/117=
94.=20
This also makes the dongle work on my iBook G4.

Can you pleas merge it ?

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
