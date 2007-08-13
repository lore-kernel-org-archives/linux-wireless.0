Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:33434 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S940264AbXHMIFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 04:05:41 -0400
Message-ID: <46C010D2.7020702@warmcat.com>
Date: Mon, 13 Aug 2007 09:05:38 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Hans de Goede <j.w.r.degoede@hhs.nl>,
	linux-wireless@vger.kernel.org
Subject: Re: Recent linux-wireless git changes have broken my prism54pci card
References: <46BFF10B.1090307@hhs.nl> <46BFFE4F.802@warmcat.com> <46C00D1E.3000807@hhs.nl> <200708130058.47778.flamingice@sourmilk.net>
In-Reply-To: <200708130058.47778.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Monday 13 August 2007 00:49, Hans de Goede wrote:
>> I already found that one, but there is no drivers/net/wireless/mac80211 dir
>> there. What am I missing?
>>
> John Linville recently collapsed that directory into driver/net/wireless.

Looking through that gitweb HEAD, the mac80211 stuff appears to be just
plain absent at the moment as Hans says:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-dev.git;a=blob;f=drivers/net/wireless/Kconfig;h=ae27af0141c02ee5b6100aa7f512dfdd77c4e703;hb=HEAD

-Andy
