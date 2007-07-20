Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35885 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760544AbXGTOgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 10:36:14 -0400
Message-ID: <46A0C851.2040302@lwfinger.net>
Date: Fri, 20 Jul 2007 09:36:01 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Andy Green <andy@warmcat.com>
CC: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com> <20070719191052.GC6603@tuxdriver.com> <200707192139.14930.mb@bu3sch.de> <46A050B4.3060500@warmcat.com>
In-Reply-To: <46A050B4.3060500@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> 
> I never heard of a special blessed firmware before, I don't think that
> the driver made any dmesg when given the non-blessed one, if that is
> what it is?  I was given this firmware by the traditional "person on
> IRC" and don't know where it came from, but I still have it here if any
> versioning can be extracted from it.

Just as API's and ABI's change, the writers of firmware can change their layout, which is what 
happened here. Nothing "blessed", just one behavior before, and a second after, the change. The 
version info can be gotten from fwcutter.

Larry

