Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:49381 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXKHGKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 01:10:39 -0500
Date: Thu, 8 Nov 2007 07:10:37 +0100
To: Ian Schram <ischram@telenet.be>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [RFC][PATCH] iwlwifi using mac80211_leds
Message-ID: <20071108061037.GB20580@gamma.logic.tuwien.ac.at> (sfid-20071108_061044_642650_733DF243)
References: <47164DA9.3050001@telenet.be> <471E92FC.1000305@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <471E92FC.1000305@telenet.be>
From: Norbert Preining <preining@logic.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mi, 24 Okt 2007, Ian Schram wrote:
> This is the second version of this patch with a few several bugfixes,
> please test this one instead. I also included a 4965 part to the patch

Works nicely with 2.6.24-rc2. Finally the led of my laptop is orange
again. Thanks.

Needed only a simple Kconfig fix.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TOTTERIDGE (n.)
The ridiculous two-inch hunch that people adopt when arriving late for
the theatre in the vain and futile hope that it will minimise either
the embarrassment of the lack of visibility for the rest of the
audience. c.f. hickling.
			--- Douglas Adams, The Meaning of Liff
