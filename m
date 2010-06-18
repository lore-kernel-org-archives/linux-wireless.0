Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:47303 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758397Ab0FRKtc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 06:49:32 -0400
Message-ID: <20100618134930.124225d4fsi8w1fk@naisho.dyndns.info>
Date: Fri, 18 Jun 2010 13:49:30 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	"Bob Copeland" <bcopeland@gmail.com>
Subject: Re: [PATCH] ath5k: disable ASPM
References: <20100528100901.14580.1322.stgit@fate.lan>
	<1276806785.20754.8.camel@maxim-laptop>
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info>
	<1276856142.9114.1.camel@maxim-laptop>
In-Reply-To: <1276856142.9114.1.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Maxim Levitsky" <maximlevitsky@gmail.com>:

>> (ok, I might switch back ath5k to work on this, but opening AAO is
>> pain.. on the other hand, I'm just user in this case and pretty
>> unwilling to work with dual-license)
> What do you mean?

Patch I made uses GPL code from e1000e, but since ath5k is  
dual-licensed so patch can't be accepted. So if I got it right, patch  
has to be remade from scratch by someone who really knows about pci  
registers etc. I don't, and learning this to fix something that is  
already fixed in my point of view is waste of (my) time.

>> I did test device with L0s+L1 enabled (aspm=force), on this setup
>> device fails within seconds. I tested patch with disabling L1 but not
>> L0s, still fails but after longer time. I did _not_ test with L0s off
>> but L1 enabled. So maybe it would be worth to test this patch with
>> just disabling L0s.
> I did, and it works.

Yeah, I noticed your reply at bugzilla (#13892).

  -Jussi

