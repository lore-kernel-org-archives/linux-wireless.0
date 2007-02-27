Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:42688 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbXB0HQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 02:16:30 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HLwY2-00013z-Ta
	for linux-wireless@vger.kernel.org; Tue, 27 Feb 2007 02:14:55 -0500
Subject: Re: [PATCH] d80211: fix sparse warnings
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1172539109.5835.28.camel@dv>
References: <1172530759.3870.205.camel@johannes.berg>
	 <1172539109.5835.28.camel@dv>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 02:16:25 -0500
Message-Id: <1172560585.19312.20.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-02-26 at 20:18 -0500, Pavel Roskin wrote:

> Great catch!  I have reduced this to a simple test case where sparse
> behaves unreasonably, and I'm going to send it to sparse developers as a
> bug report.

Linus has replied that it's not a bug:

http://marc.theaimsgroup.com/?l=linux-sparse&m=117254997313979&w=2

He suggests in the end how to avoid that warning.

-- 
Regards,
Pavel Roskin

