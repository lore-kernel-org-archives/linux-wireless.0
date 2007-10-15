Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iggypop2.siwnet.net ([81.216.65.12]:63742 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbXJOHFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 03:05:07 -0400
Message-ID: <56412.80.169.182.16.1192431887.squirrel@www.dactylis.com> (sfid-20071015_080513_491220_46EFBE78)
In-Reply-To: <1192217047.4770.61.camel@johannes.berg>
References: <fdqhn4$qab$1@sea.gmane.org>
    <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
    <1192094159.4770.21.camel@johannes.berg>
    <200710112005.56101.IvDoorn@gmail.com>
    <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
    <1192216713.4770.58.camel@johannes.berg>
    <1192217047.4770.61.camel@johannes.berg>
Date: Mon, 15 Oct 2007 09:04:47 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
From: "Marcus Better" <marcus@better.se>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Michael Wu just pointed out the error in my previous patch. I missed the
> outer loop, we need to break from it as well.

The new patch doesn't seem to solve the problem either. I get the same
association failure as before.

Marcus


