Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:36099 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbbJAXKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 19:10:21 -0400
Received: by vkgp185 with SMTP id p185so4047130vkg.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2015 16:10:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151001154015.GJ7340@mwanda>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
	<1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
	<20151001154015.GJ7340@mwanda>
Date: Fri, 2 Oct 2015 07:56:28 +0900
Message-ID: <CAKV=isutNb+AeLyZPO9x=h90FeQr8+JfTOFka0bY7SoWofwLbQ@mail.gmail.com> (sfid-20151002_011025_772488_4C44C4CD)
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 2, 2015 at 12:40 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Thu, Oct 01, 2015 at 10:43:55PM +0900, Chaehyun Lim wrote:
>> This patch replaces int8_t with s8 that is a preferred type.
>>
>
> It would be better to just use int.

I always appreciate your comment. I've sent a patch before after
changing by int, but it was rejected.
At that time I had a suggestion to be careful to change data type, so
I just change by s8 now.

Thanks
Chaehyun Lim
>
> regards,
> dan carpenter
>
