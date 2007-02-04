Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:30606 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXBDSb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 13:31:28 -0500
Received: by wr-out-0506.google.com with SMTP id i22so1054213wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2007 10:31:27 -0800 (PST)
Message-ID: <9e4733910702041031i5edd6dfeq7f8c5179fee5e00e@mail.gmail.com>
Date: Sun, 4 Feb 2007 13:31:27 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: SoftMAC vs FullMAC
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <20070204123048.4bhesocg4kosgscg@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/4/07, Pavel Roskin <proski@gnu.org> wrote:
> In fact, Atheros chips are not that intelligent to be treated as FullMAC, but
> going to d80211 removes many chip specific features.

What types of features are removed? For example Atheros turbo mode can
be treated like another PHY layer implementation.

If it is just off-loading the implementation of standard behavior then
we may actually be better off ignoring this capability and
implementing the standard behavior in the host.

It's not even clear to me that doing encryption is a wireless
co-processor is a win. It is almost certain that the host can perform
the same algorithms many times faster that an embedded wireless
processor.  Moving encryption onto the host reduces the latency of the
connection.

-- 
Jon Smirl
jonsmirl@gmail.com
