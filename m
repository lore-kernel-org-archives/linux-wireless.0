Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758471Ab1FVWGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 18:06:36 -0400
Received: by iyb12 with SMTP id 12so1045157iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 15:06:35 -0700 (PDT)
Message-ID: <4E026768.1070306@lwfinger.net> (sfid-20110623_000639_592217_4E915353)
Date: Wed, 22 Jun 2011 17:06:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>
CC: Hauke Mehrtens <hauke@hauke-m.de>, mb@bu3sch.de,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ssb: fix ssb clock rate according to broadcom source
References: <1308681113-4706-1-git-send-email-hauke@hauke-m.de>	<1308682400-25953-1-git-send-email-hauke@hauke-m.de>	<4E010EE6.9060605@lwfinger.net> <20110622070212.076777c0@Nokia-N900>
In-Reply-To: <20110622070212.076777c0@Nokia-N900>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2011 02:02 AM, Michael Büsch wrote:
> On Tue, 21 Jun 2011 16:36:38 -0500
> Larry Finger<Larry.Finger@lwfinger.net>  wrote:
>> This patch sent me looking to find the public source for this routine. After
>> finding it in the source section of Broadcom-wl, I noticed there is some
>> additional code that is not implemented in the ssb version. Should this
>> additional material be implemented, or is it not applicable?
>
> could you quote that function here? That would be way easier to get what were talking about.

The file in question is found from the Broadcom wl driver. When you untar it 
into directory "broadcom", the file is broadcom/src/shared/siutils.c.

My initial conclusion that the clock_rate routine from the above file and 
drivers/ssb/main.c were different was wrong. When I checked them again, they do 
exactly the same thing after this patch is applied. Sorry for the noise.

Larry
