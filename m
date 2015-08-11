Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33646 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbbHKBpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 21:45:04 -0400
Received: by vkbc123 with SMTP id c123so16913611vkb.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2015 18:45:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150810120154.GA22283@us.netrek.org>
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
	<55C4DDF5.6010901@lwfinger.net>
	<CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
	<20150810041957.GA7681@us.netrek.org>
	<CAAd53p5Lwm-2qDh=hc8Kp8XYUafxksyQn9ouOjHW_PymPQ-i9w@mail.gmail.com>
	<20150810120154.GA22283@us.netrek.org>
Date: Tue, 11 Aug 2015 09:45:03 +0800
Message-ID: <CAAd53p7rskK4a=mX4Gxk+6MBjmPpuMWW50XiciBLiZoT0JfyKQ@mail.gmail.com> (sfid-20150811_034509_510847_FE053577)
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

I think the newer firmware in conjunction with "fwlps=0"
should work fine in my (limited) testing.

Thanks,
Kai-Heng Feng


On Mon, Aug 10, 2015 at 8:01 PM, James Cameron <quozl@laptop.org> wrote:
> On Mon, Aug 10, 2015 at 06:47:05PM +0800, Kai Heng Feng wrote:
>> Do you use Ubuntu Trusty (14.04)?
>
> Yes, that's what I'm using.
>
>> The rtl8723be firmware is not up-to-date in Trusty's linux-firmware.
>> You can grab the newer one from the upstream linux-firmware.
>
> Thanks, but both seem to work fine (apart from the issue in this
> thread), and I don't have a list of what has changed.
>
> --
> James Cameron
> http://quozl.linux.org.au/
