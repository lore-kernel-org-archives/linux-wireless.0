Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39610 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab0FPFv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 01:51:29 -0400
Received: by vws13 with SMTP id 13so2236351vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 22:51:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100615195157.GC2415@tuxdriver.com>
References: <1276579217-6837-1-git-send-email-vnatarajan@atheros.com>
	<20100615195157.GC2415@tuxdriver.com>
Date: Wed, 16 Jun 2010 11:21:27 +0530
Message-ID: <AANLkTimprPdviZPX26qcH-uM8FyNY09JEH3kRvqwDi-S@mail.gmail.com>
Subject: Re: [PATCH] ath9k: Modify LED blinking pattern during wifi activity.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 1:21 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Jun 15, 2010 at 10:50:17AM +0530, Vivek Natarajan wrote:
>> Some vendors require the LED to be ON always irrespective of any
>> radio activity. Introducing a module parameter to enable this,
>> so that one can choose between always on or led blink during
>> activity.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>
> Any particular reason the always-on behaviour is the default?

There is no specific reason for setting it as default. It is only that
some customers preferred the led to be always on instead of blinking.

Thanks
Vivek.
