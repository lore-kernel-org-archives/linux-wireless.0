Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25409 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030184AbcFBP0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 11:26:24 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mike@fireburn.co.uk" <mike@fireburn.co.uk>
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
Date: Thu, 2 Jun 2016 15:26:15 +0000
Message-ID: <87k2i7y5m2.fsf@kamboji.qca.qualcomm.com> (sfid-20160602_172743_359664_C6A0E9E4)
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
	<871t4fzn1x.fsf@kamboji.qca.qualcomm.com>	<57504F05.3040200@candelatech.com>
In-Reply-To: <57504F05.3040200@candelatech.com> (Ben Greear's message of "Thu,
	2 Jun 2016 08:21:41 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> I found a lot of problems with this code as well, and the 5 patches
> starting from the URL below fixed the issues for me.
>
> They are stuck as 'NA' in patchwork, but I don't know why.
>
> http://lists.infradead.org/pipermail/ath10k/2016-April/007218.html

ath10k has a separate patchwork instance, did you look at the correct
one? I have quite a lot of patches from you in deferred state because of
the patch bomb, but I'm hoping to go through them soon.

https://patchwork.kernel.org/project/ath10k/list/?state=10&delegate=25621&order=date

-- 
Kalle Valo