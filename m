Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60725 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1FGVvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 17:51:09 -0400
Received: by qyg14 with SMTP id 14so2759103qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 14:51:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D69C90565D53114396BF743585AF5A0912A8674CC4@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <D69C90565D53114396BF743585AF5A0912A8674CC4@VSHINMSMBX01.vshodc.lntinfotech.com>
Date: Tue, 7 Jun 2011 23:51:08 +0200
Message-ID: <BANLkTikMW7H=NYqX0N-TbhpBd61SSK9ayA@mail.gmail.com> (sfid-20110607_235114_079452_A42FBB54)
Subject: Re: bcm4329 background scanning
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Viral Mehta <Viral.Mehta@lntinfotech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/7 Viral Mehta <Viral.Mehta@lntinfotech.com>:
> I was looking at bcm4329 driver to understand how scanning is happening ?
>
> I have two questions,
> 1. Does bcm4329 supports background scanning ?
>
> from looking at the code, it looks like NO

I think bcm4329 barely maintained and noone really work on it.

Did you think about switching to brcmfmac? It receives some love from
Broadcom and it's more probably you will get some help with this one.

-- 
Rafał
