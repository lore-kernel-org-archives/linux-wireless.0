Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51941 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HTNby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Aug 2011 09:31:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E4FAFB7.4050207@bfs.de>
References: <20110818133809.GG4786@shale.localdomain>
	<CACna6rzwxA=OzQQ_VknsSq8BXXoH8U=GpdfkRTBWjFSNSjwsAA@mail.gmail.com>
	<4E4FAFB7.4050207@bfs.de>
Date: Sat, 20 Aug 2011 15:31:53 +0200
Message-ID: <CACna6rwwHSHuNWL8ykmJttoRi_4wGzS9-iRceNP+=OSyf8JZ5Q@mail.gmail.com> (sfid-20110820_153203_907743_89E69032)
Subject: Re: [patch -next] bcma: signedness bug in bcma_get_next_core()
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: wharms@bfs.de
Cc: Dan Carpenter <error27@gmail.com>,
	"open list:BROADCOM SPECIFIC..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 sierpnia 2011 14:59 użytkownik walter harms <wharms@bfs.de> napisał:
>
>
> Am 20.08.2011 14:23, schrieb Rafał Miłecki:
>> W dniu 18 sierpnia 2011 15:38 użytkownik Dan Carpenter
>> <error27@gmail.com> napisał:
>>> The u32 would never be less than zero so the error handling would
>>> break.  I changed it to int.
>>
>> In declaration we use s32:
>> static s32 bcma_erom_get_mst_port(struct bcma_bus *bus, u32 **eromptr);
>>
>> Doesn't it sound better to use s32 instead of int?
>>
>
> aktualy int sounds better that s32 for me.

Will you care to replace function return type as well?

-- 
Rafał
