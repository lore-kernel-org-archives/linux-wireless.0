Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37518 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182AbaGILpe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 07:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAGm1_kvTYiDZDuFrB9X1ZOCxrhPC_NE_UzzY8PoBpdZHrQgv_A@mail.gmail.com>
References: <1404898305-15588-1-git-send-email-eliad@wizery.com>
	<CAGm1_kvTYiDZDuFrB9X1ZOCxrhPC_NE_UzzY8PoBpdZHrQgv_A@mail.gmail.com>
Date: Wed, 9 Jul 2014 14:45:33 +0300
Message-ID: <CAB3XZEeC8AeAw03Va6WZ_WHwy6YABkSjg0BMdf=6gGu1UyncSA@mail.gmail.com> (sfid-20140709_134546_984206_7478BADB)
Subject: Re: [PATCH] wlcore: add basic device-tree support
From: Eliad Peller <eliad@wizery.com>
To: Yegor Yefremov <yegorslists@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 9, 2014 at 2:00 PM, Yegor Yefremov
<yegorslists@googlemail.com> wrote:
> On Wed, Jul 9, 2014 at 11:31 AM, Eliad Peller <eliad@wizery.com> wrote:
>> When running with device-tree, we no longer have a board file
>> that can set up the platform data for wlcore.
>> Allow this data to be passed from DT.
>>
>> For now, parse only the irq used. Other (optional) properties
>> can be added later on.
>
> What about adding support for "mac-address"
> (Documentation/devicetree/bindings/net/ethernet.txt) node or will it
> be automatically available?
>
the mac address is currently either read from the device itself or
from the nvs (calibration) file.
i guess additional support for such dt properties can be added later
on, if needed.

Eliad.
