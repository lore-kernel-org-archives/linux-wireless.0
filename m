Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43837 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab1KCH3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 03:29:20 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless git trees returning to kernel.org
References: <20111102180946.GC12168@tuxdriver.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 03 Nov 2011 09:29:18 +0200
In-Reply-To: <20111102180946.GC12168@tuxdriver.com> (John W. Linville's message of "Wed\, 2 Nov 2011 14\:09\:46 -0400")
Message-ID: <8739e5br5d.fsf@purkki.adurom.net> (sfid-20111103_082931_022495_7D61945F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> FYI...
>
> I have migrated the wireless git trees back to the kernel.org
> infrastructure.  As of right now, the trees are identical between
> kernel.org and infradead.org.  Further updates likely will only go
> to kernel.org, so plan accordingly.

Once you stop updating infradead.org please remove the trees from the
server. Otherwise people might be accidentally still using the old
tree and not getting the latest updates. I have quite a few clones on
my machines which follow your trees and most likely I don't remember
to update all of them.

-- 
Kalle Valo
