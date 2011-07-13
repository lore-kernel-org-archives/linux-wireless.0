Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45853 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169Ab1GMJlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 05:41:23 -0400
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713093450.GP18655@shale.localdomain> (sfid-20110713_113653_791351_AC16E3B9)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713092257.GN18655@shale.localdomain>
	 <1310549324.3873.8.camel@jlt3.sipsolutions.net>
	 <20110713093450.GP18655@shale.localdomain>
	 (sfid-20110713_113653_791351_AC16E3B9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 11:41:08 +0200
Message-ID: <1310550068.3873.9.camel@jlt3.sipsolutions.net> (sfid-20110713_114131_384954_90374E2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 12:34 +0300, Dan Carpenter wrote:
> On Wed, Jul 13, 2011 at 11:28:44AM +0200, Johannes Berg wrote:
> > On Wed, 2011-07-13 at 12:22 +0300, Dan Carpenter wrote:
> > 
> > > warn: returning -1 instead of -ENOMEM is sloppy
> > 
> > out of curiosity -- why does it say "instead of -ENOMEM"? -1 really gets
> > interpreted as "-EPERM" (since EPERM == 1)
> 
> It's for an allocation failure.  The code returns -1 (-EPERM) but it
> should be returning -ENOMEM.

Ah, so it looks at the context of it, cool.

johannes

