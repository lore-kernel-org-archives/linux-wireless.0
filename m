Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61002 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1ISSoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 14:44:16 -0400
Received: by qyk30 with SMTP id 30so3059952qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 11:44:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E778A1C.5020206@openwrt.org>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
 <1316453903-75710-2-git-send-email-nbd@openwrt.org> <1316453903-75710-3-git-send-email-nbd@openwrt.org>
 <CAB=NE6UhC=am2aVXwf+v4g7ME_49Nv47SZwSNetLgJpRV-=BkA@mail.gmail.com> <4E778A1C.5020206@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 11:43:56 -0700
Message-ID: <CAB=NE6WLfhEb0X4u9g87oE3poNzPmKr-Z8H554tZ_erJ8-rRjg@mail.gmail.com> (sfid-20110919_204427_773651_292696FE)
Subject: Re: [PATCH v2 3/4] ath: remove ath_regulatory::current_rd_ext
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 11:29 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-09-19 8:18 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Sep 19, 2011 at 10:38 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>
>>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>
>> Can you document on the patch commit log why you do remove this.
>
> Because it's unused

Why is it unused?

  Luis
