Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54465 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbYGRPkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 11:40:07 -0400
Subject: Re: [PATCH] ath5k: fix recursive locking in ath5k_beacon_update
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080718134345.M6916@bobcopeland.com>
References: <20080718134345.M6916@bobcopeland.com>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 11:39:59 -0400
Message-Id: <1216395599.18320.7.camel@dv> (sfid-20080718_174019_455427_DD282F58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-18 at 09:50 -0400, Bob Copeland wrote:
> Hi all, 
> 
> I found a lockdep error while playing with AP mode on ath5k.  I think
> this is triggerable today in ad-hoc mode.

I think it's a perfect candidate for 2.6.27.  If it can affect actual
functionality, it should go to 2.6.26.1.

-- 
Regards,
Pavel Roskin
