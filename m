Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56304 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaIKLAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 07:00:51 -0400
Message-ID: <1410433248.22863.11.camel@jlt4.sipsolutions.net> (sfid-20140911_130055_100729_4C3DE83F)
Subject: Re: [PATCH v3 1/2] cfg80211: add ops to query mesh proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 11 Sep 2014 13:00:48 +0200
In-Reply-To: <CAGnRvuovr_POseervRNz3hRU3DSJ+pe5iYrL=4xc5BnjsQEDKA@mail.gmail.com> (sfid-20140911_124339_422660_88C63473)
References: <1409922404-8217-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1409922404-8217-2-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1410430692.22863.2.camel@jlt4.sipsolutions.net>
	 <CAGnRvuovr_POseervRNz3hRU3DSJ+pe5iYrL=4xc5BnjsQEDKA@mail.gmail.com>
	 (sfid-20140911_124339_422660_88C63473)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 12:43 +0200, Henning Rogge wrote:
> On Thu, Sep 11, 2014 at 12:18 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-09-05 at 15:06 +0200, Henning Rogge wrote:
> >> Add two new cfg80211 operations for querying the content of the the mac80211s proxy path table
> >
> > Please use shorter line lengths,
> 
> "git send-email" does not wrap the commit messages (first time to send
> a patch like this for me)?

Nothing ever wraps commit messages but the user, afaik :)

johannes

