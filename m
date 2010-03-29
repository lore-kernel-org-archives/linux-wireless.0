Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47995 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0C2UAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:00:10 -0400
Date: Mon, 29 Mar 2010 15:47:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
Message-ID: <20100329194745.GH4984@tuxdriver.com>
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4BB10110.9090202@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 09:35:44PM +0200, René Bolldorf wrote:
> On 03/29/10 21:20, Larry Finger wrote:
>> Ren�,
>>
>> When you have a wireless problem, please post it to
>> linux-wireless@vger.kernel.org. The Linux Kernel Mailing List may or may not be
>> appropriate.
>>
>> To help in diagnosing your problem, please apply this patch and post the output
>> line that it produces. On my system, it shows
>>
>> ssb: chip_id 0x4312, status 0x10
>>
> and on my: ssb: chip_id 0x4312, status 0x12
>> Please also post the output of 'lspci -nnv | grep 14e4'.
> Yep:
> 01:00.0 Network controller [0280]: Broadcom Corporation BCM4312  
> 802.11b/g [14e4:4315] (rev 01)

OK, I'm new to the thread -- what exactly is the issue?  Was your
device working previously?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
