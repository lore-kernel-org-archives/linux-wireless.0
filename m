Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbaHNWSV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 18:18:21 -0400
Date: Thu, 14 Aug 2014 15:18:09 -0700 (PDT)
Message-Id: <20140814.151809.1355093138463959620.davem@redhat.com> (sfid-20140815_001829_957683_2ACB0252)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless 2014-08-14
From: David Miller <davem@redhat.com>
In-Reply-To: <20140814183253.GF4953@tuxdriver.com>
References: <20140814183253.GF4953@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 14 Aug 2014 14:32:53 -0400

> Please pull this batch of fixes intended for the 3.17 stream...
> 
> Arend van Spriel brings two brcmfmac fixes, one which fixes a memory
> leak and one which corrects some merge damage.
> 
> Emmanuel Grumbach fixes Linus's iwlwifi firmware-related log spam.
> 
> Rickard Strandqvist does some proper NULL termination after a call
> to strncpy.
> 
> Ronald Wahl corrects a carl9170 problem with sending URBs with the
> wrong endpoint type (resulting in log spam).
> 
> Please let me know if there are problems!

Pulled, thanks John.

I'm really happy that you send the iwlwifi regression fix so quickly!
