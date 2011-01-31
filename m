Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37595 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab1AaKXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 05:23:34 -0500
Received: by qyj19 with SMTP id 19so3233443qyj.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 02:23:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110131094624.GA20641@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	<1296229671-3041-7-git-send-email-sgruszka@redhat.com>
	<1296231817.7388.18.camel@wwguy-ubuntu>
	<20110128164136.GF2452@redhat.com>
	<1296256821.8832.1.camel@wwguy-ubuntu>
	<20110131094624.GA20641@redhat.com>
Date: Mon, 31 Jan 2011 11:23:33 +0100
Message-ID: <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
Subject: Re: [PATCH 7/8] iwlagn: remove CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/31 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Fri, Jan 28, 2011 at 03:20:21PM -0800, wwguy wrote:
>> > What is easiest and less time consuming:
>> >
>> > this:
>> >
>> > $ mv /lib/firmware/iwlwifi-5000-exp.ucode /lib/firmware/iwlwifi-5000-exp.ucode.not_use
>> >
>> > or this:
>> >
>> > $ make menuconfig
>> > navigate to find option and edit it
>> > $ make modules
>> > $ make modules_install
>> >
>> > ?
>> >
>> > > Also put it in Kconfig file, so it is easy for user to see they are
>> > > using experimental option. Agree?
>> >
>> > Not really. I believe someone who download a tarball, unpack it and copy
>> > files to /lib/firmware is pretty much aware what he/she is doing.
>> >
>> Agree whoever download the tarball know what he/she is doing, but I am
>> not fully agree the driver always use experimental uCode if it is in the
>> firmware directory
>
> I do not understand what for you need that, but ok, I can live with it.
>
> John, please skip this patch.

Maybe make it module parameter? Like use_experimental_fw, default to 0?

-- 
Rafał
