Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55337 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbZIPDfg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 23:35:36 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2009 20:35:40 -0700
Date: Tue, 15 Sep 2009 20:35:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Zhifeng Cai <Zhifeng.Cai@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Kevin Hayes <kevin@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC 0/3] atheros: final steps to let ar9271 use ath9k hw code
Message-ID: <20090916033537.GB12269@mosca>
References: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2009 at 07:55:51PM -0700, Luis Rodriguez wrote:
> Instead of building ar9271 by linking the same code together we
> export the shared ath9k hw code to ath and leave the ath9k prefix
> for ar9k family hw code.
> 
> This should help the development of ar9271 as you no longer need
> to run scripts to fetch common hw code, instead all hw code will
> now be built on ath.ko.
> 
> To get all pending patches to work on ar9271 you can now fetch a
> new 2.2 MB file, which will apply on today's wireless-testing:
> 
> http://bombadil.infradead.org/~mcgrof/patches/ath/2009/09/all-2009-09-15.patch

Given that we are keeping the ath9k_htc name and this will be under ath/ath9k_htc,
the page and git tree has been renamed:

http://wireless.kernel.org/en/users/Drivers/ath9k_htc
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath9k_htc.git

That is unless of course someone else has a better name suggestion.

  Luis
