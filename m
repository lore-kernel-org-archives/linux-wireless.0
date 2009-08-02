Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53755 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZHBFte (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 01:49:34 -0400
Received: by bwz19 with SMTP id 19so1910468bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 01 Aug 2009 22:49:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249171448.3491.32.camel@localhost.localdomain>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
Date: Sun, 2 Aug 2009 08:49:33 +0300
Message-ID: <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Tomas Winkler <tomasw@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 2, 2009 at 3:04 AM, Marcel Holtmann<marcel@holtmann.org> wrote:
> Hi Tomas,
>
>> Althoug GPS is a technology w/o transmitting radio
>> and thus not a primary candidate for rfkill switch,
>> rfkill gives unified interface point for devices with
>> wireless technology.
>>
>> The input key is not supplied as it is too be deprecated.
>>
>> Cc: johannes@sipsolutions.net
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
> we don't have a GPS subsystem, but even without it, I think this is a
> good thing to have.

GPS devices are usually serial devices.

> Acked-by: Marcel Holtmann <marcel@holtmann.org>
>
> Please also send a patch updating the rfkill userspace utility.

On the way....
Tomas
