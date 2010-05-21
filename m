Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774Ab0EUSMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 14:12:15 -0400
Subject: Re: Iwlwifi and LEDS?
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: Gregy <p.gregy@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
References: <AANLkTikB8WaMyIj6CTY5wfEeVDratQ1Y8W3B_JBVllBp@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 11:07:22 -0700
Message-ID: <1274465242.12391.0.camel@abhi-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-21 at 02:11 -0700, Gregy wrote:
> Hello, I noticed you removed support for led subsystem from iwlwifi. I
> have used it to control wifi led from userspace. Is it still possible
> somehow?
> 
There is module parameter for iwlcore called 'led_mode'. 

Abhijeet
> Otherwise thank you for your work.
> 
> Gregy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


