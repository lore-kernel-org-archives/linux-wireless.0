Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2JYHUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 03:20:47 -0400
Message-ID: <1351149676.10421.2.camel@jlt4.sipsolutions.net> (sfid-20121025_092050_757713_2FB0EEC7)
Subject: Re: Regression in 3.7-rc2 for b43 and b43legacy
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Sujith Manoharan <c_manoha@qti.qualcomm.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 25 Oct 2012 09:21:16 +0200
In-Reply-To: <5088D579.9000703@lwfinger.net> (sfid-20121025_080031_863706_DB8CA858)
References: <50889F60.5090406@lwfinger.net>
	 <20616.41414.398817.807498@gargle.gargle.HOWL>
	 <5088D579.9000703@lwfinger.net> (sfid-20121025_080031_863706_DB8CA858)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-25 at 01:00 -0500, Larry Finger wrote:
> On 10/24/2012 09:19 PM, Sujith Manoharan wrote:
> > Larry Finger wrote:
> >
> > This has been fixed:
> > https://patchwork.kernel.org/patch/1625871/
> 
> That patch did the trick.

Sorry about that, I'll send a pull request including this patch soon.

johannes

