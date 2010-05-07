Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52823 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0EGAPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 20:15:12 -0400
Date: Thu, 6 May 2010 20:13:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: set IEEE80211_TX_CTL_FIRST_FRAGMENT for beacons
Message-ID: <20100507001319.GA6990@tuxdriver.com>
References: <1273171517-6264-1-git-send-email-linville@tuxdriver.com>
 <k2t43e72e891005061501h91e475f6q6cb8bc7c3bbec990@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <k2t43e72e891005061501h91e475f6q6cb8bc7c3bbec990@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 06, 2010 at 03:01:25PM -0700, Luis R. Rodriguez wrote:
> On Thu, May 6, 2010 at 11:45 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> 
> Why though?

Because it is correct, appropriate, and zero additional cost.  And
because if you use the same tx path for beacons as you use for normal
frames and if in that path you manage the sequence number in software
you should be checking that flag before bumping the sequence number.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
