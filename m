Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:46008 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085AbZGQGZm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 02:25:42 -0400
Received: by fxm18 with SMTP id 18so536381fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 23:25:40 -0700 (PDT)
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: missing piece for starting device on embedded system
References: <9e4733910907161819r4202b06fib34027bba1b672d2@mail.gmail.com>
	<9e4733910907161915y56bb0682wde4cbcb6b38cce48@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 17 Jul 2009 09:25:38 +0300
In-Reply-To: <9e4733910907161915y56bb0682wde4cbcb6b38cce48@mail.gmail.com> (Jon Smirl's message of "Thu\, 16 Jul 2009 22\:15\:12 -0400")
Message-ID: <87zlb3q10d.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

> On Thu, Jul 16, 2009 at 9:19 PM, Jon Smirl<jonsmirl@gmail.com> wrote:
>> I must be missing a piece of the necessary environment to get wireless
>> started...
>> This is an embedded environment that has not had wireless previously.
>
> Duh.. the device does not show in ifconfig until I run "ifconfig wlan0 up".

'ifconfig -a' shows all interfaces, even the ones which are down.

-- 
Kalle Valo
