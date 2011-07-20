Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52615 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1GTGQJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 02:16:09 -0400
Received: by pzk3 with SMTP id 3so5838131pzk.5
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 23:16:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110720011509.504022f8@maggie>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
	<1311113542-2540-2-git-send-email-zajec5@gmail.com>
	<20110720011509.504022f8@maggie>
Date: Wed, 20 Jul 2011 08:16:08 +0200
Message-ID: <CACna6rwMe9-dHANpDLko5yy5wu521YTGXmqBr1JYh18tYt+Z4A@mail.gmail.com> (sfid-20110720_081614_192016_71A588B1)
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just a
 one, commented
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 lipca 2011 01:15 użytkownik Michael Büsch <m@bues.ch> napisał:
> On Wed, 20 Jul 2011 00:12:20 +0200
> Rafał Miłecki <zajec5@gmail.com> wrote:
>> +              * be fixed on ssb side, but requires testing with b43,
>> +              * b43legacy and b44. */
>
> No it doesn't. b44 and b43legacy don't use 64bit DMA.
> Just fix it in ssb, please.

They (drivers) don't, but what if we start giving them routing for
64-bit DMA? AFAIU they treat 64-bit DMA as 32-bit one (according to
specs: "If 64 Bit isn't an option, Silicon Backplane and PCI-E buses
can use 32 bit DMA.").

Won't they start using 64-bit DMA in the 32-bit way but with 64-bit
routing bits?

-- 
Rafał
