Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61807 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0EUUtd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 16:49:33 -0400
Received: by wwi18 with SMTP id 18so1021866wwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 13:49:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274465242.12391.0.camel@abhi-desktop>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
	 <1274465242.12391.0.camel@abhi-desktop>
Date: Fri, 21 May 2010 22:49:31 +0200
Message-ID: <AANLkTilnK6lkypJkajiwUbhl6JlNR7S8dL6YzKUe2yd3@mail.gmail.com>
Subject: Re: Iwlwifi and LEDS?
From: Gregy <p.gregy@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 May 2010 20:07, Abhijeet Kolekar <abhijeet.kolekar@intel.com> wrote:
> On Fri, 2010-05-21 at 02:11 -0700, Gregy wrote:
>> Hello, I noticed you removed support for led subsystem from iwlwifi. I
>> have used it to control wifi led from userspace. Is it still possible
>> somehow?
>>
> There is module parameter for iwlcore called 'led_mode'.

Yes but I cannot control the led through it. I can only set one of two
modes. Before I could  use it as "connected to internet" indicator or
I could turn it off completely.

Gregy
