Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:14781 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaCLIwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 04:52:20 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jones Desougi <jones.desougi@27m.se>
CC: Joe Perches <joe@perches.com>, <ath6kl@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath6kl: use braces on both arms of if statement
References: <20140309065606.10793.67068.stgit@x230>
	<20140309065717.10793.76274.stgit@x230>
	<1394401348.6972.50.camel@joe-AO722> <53201F25.30200@27m.se>
Date: Wed, 12 Mar 2014 10:52:11 +0200
In-Reply-To: <53201F25.30200@27m.se> (Jones Desougi's message of "Wed, 12 Mar
	2014 09:47:33 +0100")
Message-ID: <87iorjg5ok.fsf@kamboji.qca.qualcomm.com> (sfid-20140312_095227_115021_7E388B9D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jones Desougi <jones.desougi@27m.se> writes:

> That inverts the meaning of the condition though.
>
>
> On 03/09/2014 10:42 PM, Joe Perches wrote:
> ...
>> -	if (bss == NULL) {
> ...
>> -	} else
>> +	if (!bss) {
>
>         if (bss) {

Yeah, that was buggy. Thanks for pointing it out.

-- 
Kalle Valo
