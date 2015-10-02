Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33747 "EHLO
	mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbJBHCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2015 03:02:46 -0400
Received: by vkgd64 with SMTP id d64so4433416vkg.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2015 00:02:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151002060622.GK7340@mwanda>
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
	<1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
	<20151001154015.GJ7340@mwanda>
	<CAKV=isutNb+AeLyZPO9x=h90FeQr8+JfTOFka0bY7SoWofwLbQ@mail.gmail.com>
	<20151002060622.GK7340@mwanda>
Date: Fri, 2 Oct 2015 16:02:45 +0900
Message-ID: <CAKV=ist=jdc+wPA6emyRe4LKPD-PP3K0XZSf1a17BQfva4r3rg@mail.gmail.com> (sfid-20151002_090249_528343_A030D7F7)
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johnny Kim <johnny.kim@atmel.com>,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 2, 2015 at 3:06 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Fri, Oct 02, 2015 at 07:56:28AM +0900, Chaehyun Lim wrote:
>> On Fri, Oct 2, 2015 at 12:40 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> > On Thu, Oct 01, 2015 at 10:43:55PM +0900, Chaehyun Lim wrote:
>> >> This patch replaces int8_t with s8 that is a preferred type.
>> >>
>> >
>> > It would be better to just use int.
>>
>> I always appreciate your comment. I've sent a patch before after
>> changing by int, but it was rejected.
>
> Probably your changelog was bad.  Using s8 is hopefully a sign that you
> are doing something very hardware specific.  In this case, it is just a
> index.
>
> Write the changelog.  "The int8_t should just be int.  It's used as an
> index into an array or -1 for not found."
>
Thank you for your comment. I'll make v2 patch after applying your suggestion.

regards
Chaehyun Lim

> regards,
> dan carpenter
>
