Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39824 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965934AbcAZOBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 09:01:34 -0500
Message-ID: <1453816889.2759.72.camel@sipsolutions.net> (sfid-20160126_150137_029677_17A13243)
Subject: Re: pull request: iwlwifi 2016-01-26
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 26 Jan 2016 15:01:29 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9D570C@hasmsx109.ger.corp.intel.com> (sfid-20160126_145757_359075_F35650DF)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9D452F@hasmsx109.ger.corp.intel.com>
	 <87h9i0qwjp.fsf@kamboji.qca.qualcomm.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E9D570C@hasmsx109.ger.corp.intel.com>
	 (sfid-20160126_145757_359075_F35650DF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > There's a conflict due to 8f57e4d930d, how should I fix it?

I think we can thus drop my patch - that commit fixes the issue that
Andrew had reported as well, and that I worked around by casting the
result... now that abs() has a consistent result, using s32 in both
sides of the min() is perfectly fine.

johannes

