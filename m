Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.232]:39925 "HELO
	nm5-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752674Ab2A1Sny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 13:43:54 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied rts setting
Date: Sun, 29 Jan 2012 02:43:47 +0800
Cc: linux-wireless@vger.kernel.org
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de> <4F23F753.8070405@openwrt.org>
In-Reply-To: <4F23F753.8070405@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201290243.47953.lindner_marek@yahoo.de> (sfid-20120128_194546_889652_C55DDC1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, January 28, 2012 21:25:39 Felix Fietkau wrote:
> On 2012-01-28 8:17 AM, Marek Lindner wrote:
> > Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
> 
> NACK, minstrel_ht sets RTS/CTS only from the second rate retry slot on,
> to increase the success probability during retransmissions. For the
> first slot, it is unset. The user supplied rts setting is not suitable
> for configuring RTS/CTS usage this way, so if you want to disable it
> entirely, you'd need to add a new setting for that.

If you think it is unsuitable do you mind elaborating what this setting is 
for? As far as I can tell minstrel_ht is the only rate control algorithm that 
decides to be smarter than the user configuring the device. Without mentioning 
this anywhere! IMHO it should be minstrel_ht explaining why this makes sense, 
not the other way round.

Regards,
Marek
