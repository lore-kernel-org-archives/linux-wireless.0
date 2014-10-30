Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36094 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161AbaJ3QVK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 12:21:10 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Belisko Marek <marek.belisko@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 30 Oct 2014 09:21:06 -0700
Subject: RE: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected
 to 5GHz
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951821545AEC@SC-VEXCH1.marvell.com> (sfid-20141030_172115_280864_16BB615C)
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
	<CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
	<CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>
	<CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com>
	<CAAfyv35G=9WyYxQZjt3EYfGC+u0z81ktXrO7LEUrADxKX3XDNA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821B47FD7@SC-VEXCH1.marvell.com>
	<CAAfyv35oXYBqQsPzLWz4k6cM44+GSmPC6TTgVoELEjM_FAoYQw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821B4843B@SC-VEXCH1.marvell.com>,<CAAfyv351AXRuZw5zYQ2=6jmJrnzLLscggzduKuL6GeQbzQgNqg@mail.gmail.com>
In-Reply-To: <CAAfyv351AXRuZw5zYQ2=6jmJrnzLLscggzduKuL6GeQbzQgNqg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marek,

>With rx_pending count imbalance + your patch on top I cannot reproduce
>allocation failure issue (tested on 1 hour iperf session).

Thanks for confirmation. I will prepare new patch for latest code and submit. It will be slightly different than the one shared with you due Rx work queue implementation in latest code.

>Reason why console was completely blocked was that iperf server eats ~
>55% cpu + kworker ~27 + ksoftirq ~14 so I think this is cause
>why console was unresponsive.

I see.

>Thanks for patches. You can add my Tested-by ;)

Sure.

Regards,
Amitkumar