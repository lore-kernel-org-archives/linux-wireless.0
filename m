Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34869 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbaG2Lln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 07:41:43 -0400
Message-ID: <1406634097.7611.1.camel@jlt4.sipsolutions.net> (sfid-20140729_134157_838093_D3B07EB5)
Subject: Re: [PATCH] regulatory: add NULL to alpha2
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Eliad Peller <eliad@wizery.com>
Date: Tue, 29 Jul 2014 13:41:37 +0200
In-Reply-To: <1402471415-22723-1-git-send-email-arik@wizery.com> (sfid-20140611_092347_345196_25D980A6)
References: <1402471415-22723-1-git-send-email-arik@wizery.com>
	 (sfid-20140611_092347_345196_25D980A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-11 at 10:23 +0300, Arik Nemtsov wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> alpha2 is defined as 2-chars array, but is used in multiple
> places as string (e.g. with nla_put_string calls), which
> might leak kernel data.
> 
> Solve it by simply adding an extra char for the NULL
> terminator, making such operations safe.
> 
> Signed-off-by: Eliad Peller <eliadx.peller@intel.com>


Applied.

johannes

