Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46956 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab1BDWzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 17:55:19 -0500
Received: by qyj19 with SMTP id 19so24842qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 14:55:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1296858885.21503.33.camel@maggie>
References: <1296858885.21503.33.camel@maggie>
Date: Fri, 4 Feb 2011 23:55:18 +0100
Message-ID: <AANLkTimo61j4K8MW7z5ssc=yjE=D--xX6oextej8q84q@mail.gmail.com>
Subject: Re: [PATCH] ssb-pcmcia: Fix parsing of invariants tuples
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Dominik Brodowski <linux@dominikbrodowski.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/4 Michael Büsch <mb@bu3sch.de>:
> This fixes parsing of the device invariants (MAC address)
> for PCMCIA SSB devices.
>
> ssb_pcmcia_do_get_invariants expects an iv pointer as data
> argument.
>
> Tested-by: dylan cristiani <d.cristiani@idem-tech.it>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> Cc: stable@kernel.org

For stable: it's regression in 2.6.33. AFAIU there is no need to apply
that for 2.6.32.

-- 
Rafał
