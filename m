Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54812 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298AbbAEPdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 10:33:37 -0500
Message-ID: <1420472013.9459.14.camel@sipsolutions.net> (sfid-20150105_163347_968451_23923B3C)
Subject: Re: [PATCH v3] cfg80211: check for carrier state only when
 offchanel CAC supported
From: Johannes Berg <johannes@sipsolutions.net>
To: Avinash Patil <patila@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Cathy Luo <cluo@marvell.com>
Date: Mon, 05 Jan 2015 16:33:33 +0100
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A6A@SC-VEXCH2.marvell.com>
References: <1420475584-5533-1-git-send-email-patila@marvell.com>
	 (sfid-20150105_120344_381788_A7E15DA0),<1420462674.9459.9.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A69@SC-VEXCH2.marvell.com>
	 (sfid-20150105_143403_923577_F829B8B6),<1420465645.9459.13.camel@sipsolutions.net>
	 <CBACCFA0AEB13A41977475BCF3E896FC66736E7A6A@SC-VEXCH2.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 06:20 -0800, Avinash Patil wrote:

> I think here we want to  do_old_check only when new_feature is
> supported; because old check is causing issue for device where new
> feature is not supported.

But then you should be testing !new_feature to do the old_check

johannes

