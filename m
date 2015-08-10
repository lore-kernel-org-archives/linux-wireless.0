Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:33286 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292AbbHJKyI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 06:54:08 -0400
Received: by vkbc123 with SMTP id c123so8897719vkb.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 03:54:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150810041957.GA7681@us.netrek.org>
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
	<55C4DDF5.6010901@lwfinger.net>
	<CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
	<20150810041957.GA7681@us.netrek.org>
Date: Mon, 10 Aug 2015 18:47:05 +0800
Message-ID: <CAAd53p5Lwm-2qDh=hc8Kp8XYUafxksyQn9ouOjHW_PymPQ-i9w@mail.gmail.com> (sfid-20150810_125413_609080_F26051EC)
Subject: Re: [PATCH] rtlwifi: rtl8723be: disable FW control power save
From: Kai Heng Feng <kai.heng.feng@canonical.com>
To: James Cameron <quozl@laptop.org>
Cc: AceLan Kao <acelan.kao@canonical.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

Do you use Ubuntu Trusty (14.04)?
The rtl8723be firmware is not up-to-date in Trusty's linux-firmware.
You can grab the newer one from the upstream linux-firmware.

Thanks,
Kai-Heng Feng


On Mon, Aug 10, 2015 at 12:19 PM, James Cameron <quozl@laptop.org> wrote:
> On Mon, Aug 10, 2015 at 11:38:09AM +0800, AceLan Kao wrote:
>> I tried using "ips=0" today and found it's not working.
>> I ping 8.8.8.8 and got below message within one hour.
>>    ping: sendmsg: No buffer space available
>
> I use both ips=0 and fwlps=0 with Ubuntu kernel and with 4.1, and the
> connection remains stable.
>
> fwlps=0 alone was not enough.
>
> ips=0 alone was not enough.
>
> Hope that helps.
>
> --
> James Cameron
> http://quozl.linux.org.au/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
