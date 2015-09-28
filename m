Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36738 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247AbbI1HoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 03:44:23 -0400
Message-ID: <1443426260.2401.2.camel@sipsolutions.net> (sfid-20150928_094426_838109_9839823B)
Subject: Re: [wireless-regdb] wireless-regdb: Update regulatory rules for
 South Africa (ZA) on 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl =?ISO-8859-1?Q?M=F6ller?= <karl@excors.net>,
	seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Mon, 28 Sep 2015 09:44:20 +0200
In-Reply-To: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net>
References: <9BEBB87E-EA6D-4219-ADC5-40C1E19DA5DA@excors.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The bands don’t quite match up and DFS/TPC is (apparently) not 
> required for 5470 - 5725. More importantly, the max transmitted power
> seems to be 1W/30dBm e.i.r.p and not 27dBm.

Without checking now, just a note: we sometimes have lower limits here
due to spectral power density, indoor/outdoor or TPC requirements.

johannes
