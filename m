Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2AYORB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 09:17:01 -0500
Date: Wed, 25 Jan 2012 15:16:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/4] rt2800usb: remove PWR_PIN_CFG=0x3
 during init
Message-ID: <20120125141641.GD4595@redhat.com> (sfid-20120125_151706_699756_CED5DDE2)
References: <1327410549-4714-1-git-send-email-sgruszka@redhat.com>
 <1327410549-4714-4-git-send-email-sgruszka@redhat.com>
 <201201241737.q0OHbmX5003698@mail.maya.org>
 <20120125095407.GA3406@redhat.com>
 <4F1FFC87.3060206@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F1FFC87.3060206@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 25, 2012 at 01:58:47PM +0100, Andreas Hartmann wrote:
> I removed Patch 1 and 4 - the problem didn't change. I think it's not
> patch related, but system related: This was the first time, I tested
> with this notebook (because compiling is much more fast :-)) and to get
> more timing issues: this notebook is a Core i5 (the other was a
> CeleronM). Besides that, there is another kernel version (3.2 vs.
> 2.6.37.6) and a completely new compat-wireless.

Ok, so this seems to be usb core regression between 2.6.37 and 3.2, not
related with patches. Since you sent your email as reply for my patch
posting, I was confused.

Stanislaw
