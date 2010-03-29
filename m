Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40341 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0C2UpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:45:09 -0400
Date: Mon, 29 Mar 2010 16:30:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?Ren=E9?= Bolldorf <xsecute@googlemail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
Message-ID: <20100329203005.GK4984@tuxdriver.com>
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com> <4BB10B62.9070408@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4BB10B62.9070408@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 10:19:46PM +0200, René Bolldorf wrote:
> On 03/29/10 21:47, John W. Linville wrote:

>> OK, I'm new to the thread -- what exactly is the issue?  Was your
>> device working previously?
>>
>> John
>
> The problem is since commit fcb54b0bf7d3fe730c2b72e224bc616e358f24cb, my  
> b43 (4312)
> device doesn't work because i get the message "No SPROM available" and  
> then the device get's disabled.
>
> My colleague have the same problem. I have made a patch for that but it  
> seems thats not work for all 4312 devices. I and my colleage have the  
> same netbook for testing purposes so the patch work while we have the  
> same chip status.
>
> The problem is I think: Larry had written his output is ssb: chip_id  
> 0x4312, status 0x10, he have a different chip status.
> What to do? Any ideas?

Not really, no... :-(

Larry, any chance the definitions of those OTP_SEL bits are inverted
between 4325 and 4312?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
