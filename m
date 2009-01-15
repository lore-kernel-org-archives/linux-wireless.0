Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a80-127-65-128.adsl.xs4all.nl ([80.127.65.128]:13892 "EHLO
	linux.wilsoft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbZAOIeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 03:34:46 -0500
Received: from hp4000.wilsoft.nl ([192.168.4.5])
	by linux.wilsoft.nl with esmtp (Exim 4.69)
	(envelope-from <listsrv@wilsoft.nl>)
	id 1LNNgW-0004vE-OQ
	for linux-wireless@vger.kernel.org; Thu, 15 Jan 2009 09:34:40 +0100
From: "W. van den Akker" <listsrv@wilsoft.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH v4 02/11] ath9k: convert to use bus-agnostic DMA routines
Date: Thu, 15 Jan 2009 09:34:39 +0100
References: <1231960632-4452-1-git-send-email-juhosg@openwrt.org> <496EEE8B.3030702@openwrt.org> <18798.62140.234415.246664@gargle.gargle.HOWL>
In-Reply-To: <18798.62140.234415.246664@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-2022-jp"
Message-Id: <200901150934.39506.listsrv@wilsoft.nl> (sfid-20090115_093451_008889_FBCDBF7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009, you wrote:
> Gabor Juhos wrote:
> > Sujith  rta:
> > > Gabor Juhos wrote:
> > >> Convert to use bus-agnostic DMA routines to make it usable on AHB bus
> > >> as well.
> > >
> > > This pretty much makes the previous patch redundant.
> >
> > Yes. Although i can merge the two patches, but in my opinion it is easier
> > to review them in this way.
>
> Alright.
> Otherwise, the series looks okay to me.
>

Can this perhaps a solution for superious system hangups? See also threat 
'Still problems to get aht9k in accesspoint mode. Kernel hangs'

gr,
Willem

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.

