Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34591 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2BOTeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 14:34:18 -0500
Message-ID: <4F3C08B4.8010103@canonical.com> (sfid-20120215_203441_648063_2D298136)
Date: Wed, 15 Feb 2012 12:34:12 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rtlwifi: rtl8192se firmware load can overflow target
 buffer
References: <1328833192-10681-1-git-send-email-Larry.Finger@lwfinger.net> <20120215185525.GE4379@tuxdriver.com> <4F3C0421.20506@lwfinger.net>
In-Reply-To: <4F3C0421.20506@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2012 12:14 PM, Larry Finger wrote:
> On 02/15/2012 12:55 PM, John W. Linville wrote:
>> Is this a fix that should go to 3.3?
>
> That code has been in the driver since 3.0 and it should probably be
> packported. On the other hand, Tim's report is the first one. My
> suggestion is that it go into 3.4.
>
> In addition, I am working on a fix that will completely eliminate all
> this fixed storage.
>
> Larry
>
>

I'm fine with it being 3.4 material. The patch addresses an unlikely 
scenario.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
