Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35803 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbIQMDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 08:03:15 -0400
Received: by vkao3 with SMTP id o3so9186226vka.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 05:03:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150917103426.GB20514@sudip-pc>
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
	<1442476129-14908-3-git-send-email-chaehyun.lim@gmail.com>
	<20150917103426.GB20514@sudip-pc>
Date: Thu, 17 Sep 2015 21:03:14 +0900
Message-ID: <CAKV=isvZ2V+RgpB_Aej5cUjZ+n_9OdOb2X_0f=q6=LNouxF14A@mail.gmail.com> (sfid-20150917_140319_019332_8B038963)
Subject: Re: [PATCH V2 3/8] staging: wilc1000: replace int8_t with int
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	"tony.cho" <tony.cho@atmel.com>, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 7:34 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Thu, Sep 17, 2015 at 04:48:44PM +0900, Chaehyun Lim wrote:
>> This patch replaces int8_t with int. just use return type as int.
>>
>> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
>> ---
> but isn't int8_t is defined as char?
>

Even int8_t is defined as char, I think it's no problem to use int.
Is it need to change as char?

Regards
Chaehyun Lim

> regards
> sudip
