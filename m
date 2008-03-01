Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755172AbYCAW77 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 17:59:59 -0500
Date: Sat, 01 Mar 2008 14:59:58 -0800 (PST)
Message-Id: <20080301.145958.33975454.davem@davemloft.net> (sfid-20080301_230009_103898_9A3D3F60)
To: sam@ravnborg.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, mb@bu3sch.de,
	gordonfarquharson@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: pull request: wireless-2.6 2008-02-27
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080301130133.GA14250@uranus.ravnborg.org>
References: <20080229191058.GD3234@tuxdriver.com>
	<20080229214240.GH3234@tuxdriver.com>
	<20080301130133.GA14250@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 1 Mar 2008 14:01:33 +0100

> And that for shaving 6 bytes of a structure..

No, it's for not breaking existing userland binaries out there.  We
released 2.6.24 with the existing struct layout, we have to live with
it.
