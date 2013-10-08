Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:32847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab3JHKlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:24 -0400
Message-ID: <1381228880.13359.5.camel@jlt4.sipsolutions.net> (sfid-20131008_124132_062234_079A8C9A)
Subject: Re: [PATCH] nl80211: vendor command support
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 08 Oct 2013 12:41:20 +0200
In-Reply-To: <CAB3XZEe+vVezWHBkOt_M4pfqCu--c78EuyMEmGD2oqcpP9=c-w@mail.gmail.com> (sfid-20131008_123406_100836_D0A76060)
References: <1381222401-21999-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEe+vVezWHBkOt_M4pfqCu--c78EuyMEmGD2oqcpP9=c-w@mail.gmail.com>
	 (sfid-20131008_123406_100836_D0A76060)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 12:34 +0200, Eliad Peller wrote:

> don't you miss the rdev->cur_cmd_info initialization in case of
> vendor_cmd (like it's being done in testmode)?

Indeed, I missed that. Need to test it anyway :)

johannes

