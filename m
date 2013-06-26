Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3FZPYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:24:41 -0400
Message-ID: <1372260275.13529.15.camel@jlt4.sipsolutions.net> (sfid-20130626_172444_396791_3EED82C2)
Subject: Re: [PATCH] iw: fix incorrect bit shifting in print_ht_mcs
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Jun 2013 17:24:35 +0200
In-Reply-To: <1372259260-7061-1-git-send-email-linville@tuxdriver.com>
References: <1372259260-7061-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-26 at 11:07 -0400, John W. Linville wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> From a Coverity run on version 3.10:
> 
> iw-3.10/util.c:569:result_independent_of_operands –
> 	"mcs[10] >> 8" is 0 regardless of the values of its operands. This occurs as the bitwise first operand of '&'.
> 
> This seems more like what was intended...

Applied both, thanks.

johannes

