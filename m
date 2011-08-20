Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:15729 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab1HTM7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 08:59:39 -0400
Message-ID: <4E4FAFB7.4050207@bfs.de> (sfid-20110820_145951_216211_391B0916)
Date: Sat, 20 Aug 2011 14:59:35 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Dan Carpenter <error27@gmail.com>,
	"open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] bcma: signedness bug in bcma_get_next_core()
References: <20110818133809.GG4786@shale.localdomain> <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
In-Reply-To: <CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 20.08.2011 14:23, schrieb Rafał Miłecki:
> W dniu 18 sierpnia 2011 15:38 użytkownik Dan Carpenter
> <error27@gmail.com> napisał:
>> The u32 would never be less than zero so the error handling would
>> break.  I changed it to int.
> 
> In declaration we use s32:
> static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr);
> 
> Doesn't it sound better to use s32 instead of int?
> 

aktualy int sounds better that s32 for me.

re,
 wh
