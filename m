Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40163 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZIYEqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 00:46:07 -0400
Date: Fri, 25 Sep 2009 00:42:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] cfg80211: firmware and hardware version
Message-ID: <20090925044258.GA2722@tuxdriver.com>
References: <20090924180048.14503.9579.stgit@tikku> <43e72e890909241320j592e347die8a14f8bdd962ffb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890909241320j592e347die8a14f8bdd962ffb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 24, 2009 at 01:20:35PM -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> > Here's my suggestion how to provide firmware and hardware version to
> > user space. First I was thinking adding a new nl80211 command and
> > it looked so ugly that I decided include the versions in struct wiphy
> > instead.
> >
> > Please comment.
> 
> What was the conclusion on ethtool stuff again? I forgot.

IIRC, I suggested that the cfg80211 driver API (or just the wiphy
data structure) could be extended for appropriate bits like this,
then cfg80211 could catch ethtool operations in a way similar to how
it catches wireless extensions now.

I was thinking to look at this after I get home, maybe next week.
Others are welcome to beat me to it, of course. :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
