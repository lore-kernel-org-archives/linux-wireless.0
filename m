Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iggypop2.siwnet.net ([81.216.65.12]:61628 "EHLO
	iggypop2.siwnet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762985AbXJSHug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 03:50:36 -0400
Message-ID: <39384.80.169.182.16.1192780194.squirrel@www.dactylis.com> (sfid-20071019_085039_528758_7074BA7F)
In-Reply-To: <200710152013.20777.IvDoorn@gmail.com>
References: <fdqhn4$qab$1@sea.gmane.org>
    <35945.80.169.182.16.1192448277.squirrel@www.dactylis.com>
    <1192448723.3349.32.camel@johannes.berg>
    <200710152013.20777.IvDoorn@gmail.com>
Date: Fri, 19 Oct 2007 09:49:54 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
From: "Marcus Better" <marcus@better.se>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Ivo van Doorn wrote:
> Could you enable debugfs and use attached debugfs script to create a
> dump of the rt2x00 registers.

If you still need the debug dump for 2.0.7 (the latest working version),
can you show me how to get hold of a source tree with that version? I have
both the wireless-2.6 and rt2x00 git trees, but seem to have trouble
locating the right revision, perhaps because the tree was rebased.

Thanks,

Marcus


