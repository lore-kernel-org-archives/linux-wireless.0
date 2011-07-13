Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48923 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134Ab1GMJ2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 05:28:33 -0400
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <20110713092257.GN18655@shale.localdomain> (sfid-20110713_112439_856249_A0EE796F)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713092257.GN18655@shale.localdomain>
	 (sfid-20110713_112439_856249_A0EE796F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 11:28:44 +0200
Message-ID: <1310549324.3873.8.camel@jlt3.sipsolutions.net> (sfid-20110713_112836_176734_DAE3F020)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 12:22 +0300, Dan Carpenter wrote:

> warn: returning -1 instead of -ENOMEM is sloppy

out of curiosity -- why does it say "instead of -ENOMEM"? -1 really gets
interpreted as "-EPERM" (since EPERM == 1)

johannes

