Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389AbXHHWcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 18:32:46 -0400
Date: Wed, 8 Aug 2007 15:32:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: arm allmodconfig
Message-Id: <20070808153208.49fb7211.akpm@linux-foundation.org>
In-Reply-To: <20070808152606.9ea3010f.akpm@linux-foundation.org>
References: <20070808145705.756597b0.akpm@linux-foundation.org>
	<200708090013.06846.mb@bu3sch.de>
	<20070808152606.9ea3010f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


m68k allmodconfig:

drivers/ssb/main.c: In function 'ssb_ssb_read16':
drivers/ssb/main.c:489: error: implicit declaration of function 'readw'
drivers/ssb/main.c: In function 'ssb_ssb_read32':
drivers/ssb/main.c:497: error: implicit declaration of function 'readl'
drivers/ssb/main.c: In function 'ssb_ssb_write16':
drivers/ssb/main.c:505: error: implicit declaration of function 'writew'
drivers/ssb/main.c: In function 'ssb_ssb_write32':
drivers/ssb/main.c:513: error: implicit declaration of function 'writel'

Probably a dependency on HAS_IOMEM will fix that uup.
