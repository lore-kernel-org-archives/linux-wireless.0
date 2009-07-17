Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:45830 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618AbZGQCPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 22:15:13 -0400
Received: by an-out-0708.google.com with SMTP id d40so723876and.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 19:15:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9e4733910907161819r4202b06fib34027bba1b672d2@mail.gmail.com>
References: <9e4733910907161819r4202b06fib34027bba1b672d2@mail.gmail.com>
Date: Thu, 16 Jul 2009 22:15:12 -0400
Message-ID: <9e4733910907161915y56bb0682wde4cbcb6b38cce48@mail.gmail.com>
Subject: Re: missing piece for starting device on embedded system
From: Jon Smirl <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 9:19 PM, Jon Smirl<jonsmirl@gmail.com> wrote:
> I must be missing a piece of the necessary environment to get wireless
> started...
> This is an embedded environment that has not had wireless previously.

Duh.. the device does not show in ifconfig until I run "ifconfig wlan0 up".


-- 
Jon Smirl
jonsmirl@gmail.com
