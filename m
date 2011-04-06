Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1DFKpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 06:45:31 -0400
Subject: Re: [Patch] wireless: remove obsolete ar9170usb driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1302086160-9158-1-git-send-email-amwang@redhat.com>
References: <1302086160-9158-1-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Apr 2011 12:45:29 +0200
Message-ID: <1302086729.3811.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-06 at 18:36 +0800, Amerigo Wang wrote:
> AR9170USB is scheduled to be removed in 2.6.40.
> 
> Cc: Christian Lamparter <chunkeey@googlemail.com>

Christian already submitted this patch, and I believe it was merged.

What tree are you working against? You seem to be missing a bunch of
wireless things that _should_ be in linux-next (I was going to check but
git.kernel.org is really slow right now)?

johannes

