Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:42012 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbYCGDHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 22:07:42 -0500
Received: by rn-out-0910.google.com with SMTP id v46so473701rnb.15
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 19:07:39 -0800 (PST)
Message-ID: <43e72e890803061907j2dca57f1k6907e2942f8a70fc@mail.gmail.com> (sfid-20080307_030746_599029_B1DDD37D)
Date: Thu, 6 Mar 2008 22:07:38 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 0/8] ath5k: latest revised patches
Cc: ath5k-devel@lists.ath5k.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Bob Copeland" <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890802281456j22236cdegb4cf0c90d954af05@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 28, 2008 at 5:56 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> The following are based on Nick's patches, they address checkpatch
>  complaints, make use of pci_dev's is_pcie, and makes use of a helper
>  instead on the 7th patch. These need testing on pci-e cards. I've
>  tested it on AR5213 (MAC 0x56, PHY: 0x41), RF5211 (0x17) and RF2111
>  (0x23).

Testing was done.

>  You can also wget them from:
>
>  http://www.kernel.org/pub/linux/kernel/people/mcgrof/patches/ath5k/2008-02-28/

We need to move forward with this. Any blockers?

  Luis
