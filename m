Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43975 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1BNXo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 18:44:59 -0500
Received: by qyk12 with SMTP id 12so4338929qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 15:44:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297725710.5683.17.camel@maggie>
References: <1297725710.5683.17.camel@maggie>
Date: Tue, 15 Feb 2011 00:44:58 +0100
Message-ID: <AANLkTimjkFJrWpubECRRNybmvYdcAh3UUbMOa0iv166g@mail.gmail.com>
Subject: Re: [PATCH] ssb: Make ssb_wait_bit multi-bit safe
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/15 Michael Büsch <mb@bu3sch.de>:
> ssb_wait_bit was designed for only one-bit bitmasks.
> People start using it for multi-bit bitmasks. Make the "set" case
> is safe for this. The "unset" case is already safe.

Thanks :)

-- 
Rafał
