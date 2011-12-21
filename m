Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58964 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab1LUUPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 15:15:34 -0500
Date: Wed, 21 Dec 2011 15:09:37 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dave Taht <dave.taht@bufferbloat.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] Treat IPv6 diffserv the same as ipv4 diffserv for
 802.11e
Message-ID: <20111221200937.GG11842@tuxdriver.com> (sfid-20111221_211538_137489_5132A234)
References: <1324456905-2628-1-git-send-email-dave.taht@bufferbloat.net>
 <1324456905-2628-2-git-send-email-dave.taht@bufferbloat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1324456905-2628-2-git-send-email-dave.taht@bufferbloat.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 21, 2011 at 12:41:45AM -0800, Dave Taht wrote:
> Wireless will select a different hardware queue based on the
> top 3 bits of the diffserv field, for ipv4. Extend that queue
> selection mechanism to ipv6, and make the calls orthogonal.

The patch itself seems fine to me.  But the format needs work:

	http://linux.yyz.us/patch-format.html

Would you mind fixing-up the email and resubmitting?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
