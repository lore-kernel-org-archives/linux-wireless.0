Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:38403 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZCDOVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 09:21:51 -0500
Received: by ti-out-0910.google.com with SMTP id d10so3478527tib.23
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 06:21:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18862.36430.959276.440720@gargle.gargle.HOWL> (sfid-20090304_152153_626428_88D71CC0)
Date: Wed, 4 Mar 2009 19:51:02 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100 devices
In-Reply-To: <49AE8466.3040906@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
	<18862.1025.217829.656599@gargle.gargle.HOWL>
	<18862.4870.138381.234256@gargle.gargle.HOWL>
	<49AE8466.3040906@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Apart from the last line, this patch simply swaps the two initval sets as i see
> it. Would not be simpler to rename them, and then change this line only?
> 

I didn't bother to check if the initvals were to be swapped or not.
The patch was a line-by-line copy of the latest initvals. :-)
Figured this would also make it easier to roll out future updates.

> > +#define AR_SREV_VERSION_9100		0x014
> 
> 0x14?

Yep, this can be fixed.

Sujith
