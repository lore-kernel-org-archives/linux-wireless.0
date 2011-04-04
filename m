Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38828 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1DDUuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 16:50:13 -0400
Message-ID: <4D9A2F00.4040405@lwfinger.net>
Date: Mon, 04 Apr 2011 15:50:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Jens Axboe <jaxboe@fusionio.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.39-rc1 from commit	7eaceaccab5f40bbfda044629a6298616aeaed50
References: <4D9A0D97.1060505@lwfinger.net> <20110404194716.GB8785@sucs.org>
In-Reply-To: <20110404194716.GB8785@sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/2011 02:47 PM, Sitsofe Wheeler wrote:
> On Mon, Apr 04, 2011 at 01:27:35PM -0500, Larry Finger wrote:
>> After I pulled 2.6.39-rc1, my HP laptop failed to boot by never advancing
>> past the device detection stage on my x86_64 system. The problem was
>> bisected, which led to:
>
> Sounds like the same as http://marc.info/?t=130137969500005&r=1&w=2
> ("Commit 7eaceaccab5f40 causing boot hang.") ...

Yes it does - thanks. I wonder why Google hadn't indexed that thread.

The patch from http://marc.info/?l=linux-kernel&m=130148511426634&w=2 allows my 
computer to boot.

Larry
