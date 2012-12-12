Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:40078 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2LLQZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 11:25:10 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v10 0/3] wireless: Driver for 60GHz card wil6210
Date: Wed, 12 Dec 2012 18:25:06 +0200
Message-ID: <2874864.eaglUHDoO0@lx-vladimir> (sfid-20121212_172515_422980_0D889CF9)
In-Reply-To: <1355328278.9708.15.camel@jlt4.sipsolutions.net>
References: <1355327278-12965-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1355328278.9708.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 12, 2012 05:04:38 PM Johannes Berg wrote:
> On Wed, 2012-12-12 at 17:47 +0200, Vladimir Kondratiev wrote:
> 
> > Vladimir Kondratiev (3):
> >   wireless: Driver for 60GHz card wil6210
> 
> Since you didn't want to hear my objections on the iftype usage ...
> maybe you should not Cc me any more.
> 
> johannes
> 

Johannes,

I do hear it, and I agree with it!!!

I will work to support this new
iftype, PBSS, properly. I just don't have enough data to do it right
now. Thus, I want initial driver for the 1-st ever 60g card to be merged;
this will serve as test bed for the next framework modifications.

I recall, you was asking me why do I pushing to do 60g related
infrastructure changes when no one driver exists. I want to address this
and then return to the infrastructure.

Let's have at least something working as 1-st step. Now, I need to assemble
all pieces of the puzzle:

- initial infrastructure (done)
- minimal driver (these patches)
- tools (wpa_supplicant partially done, other patches sent; iw - partially done)
- regulatory - patches submitted.

Then, when minimal support will be in place, I can handle new features.

Hope it explain why I want to merge minimal driver 1-st.

Thanks, Vladimir
