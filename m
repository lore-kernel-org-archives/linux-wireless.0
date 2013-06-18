Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39054 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3FRN4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 09:56:16 -0400
Message-ID: <1371563762.8318.14.camel@jlt4.sipsolutions.net> (sfid-20130618_155624_158278_7481CFD6)
Subject: Re: [PATCHv2 1/5] nl80211: use attributes to parse beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 15:56:02 +0200
In-Reply-To: <1371212124-26264-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Taking the easy stuff first ...

On Fri, 2013-06-14 at 14:15 +0200, Simon Wunderlich wrote:
> only the attributes are required and not the whole netlink info, as the
> function accesses the attributes only anyway. This makes it easier to
> parse nested beacon IEs later.

I applied this.

johannes

