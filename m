Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65415 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1FHUPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 16:15:24 -0400
Received: by pvg12 with SMTP id 12so410567pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 13:15:24 -0700 (PDT)
Date: Wed, 8 Jun 2011 23:14:58 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan
 is ongoing
Message-ID: <20110608201458.GD4069@shale.localdomain> (sfid-20110608_221528_353425_DD3D5C5A)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115501.32208.82264.stgit@localhost6.localdomain6>
 <20110608200332.GC4069@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110608200332.GC4069@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 11:03:32PM +0300, Dan Carpenter wrote:
> On Wed, Jun 08, 2011 at 02:55:01PM +0300, Kalle Valo wrote:
> > -        /* Translate data to cfg80211 mgmt format */
> > -	if (ar->arWmi)
>             ^^^^^^^^^
> 	You removed this check on purpose?  Is this only NULL when
> 	the scan is canceled?

Grr...  That's the check that was just added in [PATCH 4/4] of this
exact same series!  Seriously?  Why are we submitting known wrong
patches???

regards,
dan carpenter
