Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25506 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CWFqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 01:46:36 -0400
Subject: Re: [RFC PATCHv6 0/2] mac80211: cfg80211: Roam trigger support
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho Luciano (Nokia-D/Helsinki)" <Luciano.Coelho@nokia.com>
In-Reply-To: <1269282538.7645.2.camel@jlt3.sipsolutions.net>
References: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269282538.7645.2.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 07:41:37 +0200
Message-ID: <1269322897.10120.764.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-22 at 19:28 +0100, ext Johannes Berg wrote:
> On Mon, 2010-03-22 at 12:15 +0200, Juuso Oikarinen wrote:
> > v6 of these patches incorporate more changes based on of Johannes' comments.
> > Some parts of the code was refactored to improve extendability.
> > 
> > v6 also has fixes a problem in configuring the rssi threshold and hysteresis
> > to the driver. It's now only done when associated.
> 
> I like it now :)
> 
> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

Thanks a lot for your effort on this! I too believe it's way better than
what I started out with.

-Juuso

> johannes
> 


