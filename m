Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61849 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZKTOyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 09:54:38 -0500
Received: by iwn8 with SMTP id 8so2579075iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 20 Nov 2009 06:54:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <712C9C7AD151C847B09F32EDA56A94CF0115C73C@WALQNAOMAIL1T.qnao.net>
References: <712C9C7AD151C847B09F32EDA56A94CF0115C555@WALQNAOMAIL1T.qnao.net>
	<1258687496.12864.35.camel@ct> <712C9C7AD151C847B09F32EDA56A94CF0115C73C@WALQNAOMAIL1T.qnao.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 20 Nov 2009 06:54:23 -0800
Message-ID: <43e72e890911200654g6bd78909s5b6062cd82155b6d@mail.gmail.com>
Subject: Re: Kernel oops in ath9k
To: "Douglass, Woodrow" <Woodrow.Douglass@qinetiq-na.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 20, 2009 at 5:56 AM, Douglass, Woodrow
<Woodrow.Douglass@qinetiq-na.com> wrote:
> Thanks for the quick reply Pavel! I've seen this Oops with kernel
> 2.6.31.6, as well as with the  latest linux-wireless that I downloaded
> on the 18th of november. Also, it's interesting that the card is
> identified as having a AR9280 chipset, the website for the card
> (http://www.ubnt.com/products/sr7112.php) says the card has an AR9220
> chipset. Could this be causing the problem?

Nah, your card is just PCI version of the AR9280. We just need to
distinguish that on the print on ath9k load. So PCI-express is AR9280
and mini-pci AR9220.

> I'm going to repost this to the ath9k mailing list you mentioned.

linux-wireless is fine too though no need to repost there. I just
tested your script with AR5416 and it worked fine, can you please try
the latest compat-wireless, either latest stable or bleeding edge?

http://wireless.kernel.org/en/users/Download/stable
http://wireless.kernel.org/en/users/Download

  Luis
