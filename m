Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58930 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab1EFJFt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 05:05:49 -0400
Received: by qyg14 with SMTP id 14so2333921qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 02:05:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304672497.22936.4.camel@maggie>
References: <1304635505-9824-1-git-send-email-zajec5@gmail.com>
	<1304672497.22936.4.camel@maggie>
Date: Fri, 6 May 2011 11:05:48 +0200
Message-ID: <BANLkTi=4SGkWvFCMxMiqBzAsfSXexDO-cQ@mail.gmail.com> (sfid-20110506_110553_181134_5DA68EFC)
Subject: Re: [PATCH] ssb: move ssb_commit_settings and export it
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/6 Michael Büsch <m@bues.ch>:
> On Fri, 2011-05-06 at 00:45 +0200, Rafał Miłecki wrote:
>> +EXPORT_SYMBOL(ssb_commit_settings);
>
> Don't add EXPORT_SYMBOLs, unless you also add an actual
> user within the same patch series.

OK, John please drop this. I'll resubmit this in series with b43 patch
when it's ready.

-- 
Rafał
