Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:49715 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbXI1CtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2007 22:49:24 -0400
Received: by wr-out-0506.google.com with SMTP id 36so1218736wra
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2007 19:49:23 -0700 (PDT)
Message-ID: <43e72e890709271949q3c8c2907lcc2df0aa352e6b64@mail.gmail.com>
Date: Thu, 27 Sep 2007 22:49:22 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull mac80211-misc
Cc: "Michael Wu" <flamingice@sourmilk.net>,
	"Jiri Benc" <jbenc@suse.cz>, "David Miller" <davem@davemloft.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>, "Michael Buesch" <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070928020113.GH7991@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200709181842.47419.flamingice@sourmilk.net>
	 <20070928020113.GH7991@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/27/07, John W. Linville <linville@tuxdriver.com> wrote:
> Sorry it took me a while to respond -- it has been a busy couple of
> weeks for me...
>
> On Tue, Sep 18, 2007 at 06:42:43PM -0400, Michael Wu wrote:
>
> > As you can see, most of the updates this time are from Johannes and fix a
> > number of issues. Some of them are locking issues. One is an update to the
> > driver API which breaks every mac80211 driver. I have fixed the drivers which
> > were in net-2.6.24 when I pulled a few days ago, but it appears that b43 and
> > iwlwifi are going in too.. which is somewhat unfortunate timing. Johannes has
> > an update for b43 but there isn't an api update for b43legacy or iwlwifi yet.
>
> The filter api change went to net-2.6.24 this evening.  Most of the
> drivers (i.e. all the ones already in net-2.6.24) have patches to
> adapt to the change, which I rolled into a single patch with the
> change itself.
>
> The ath5k and zd1211rw-mac80211 driver do not have patches for the
> new filter api.  I know Luis is working on one for ath5k,

I'm actually done, I've sent the patch out today.

  Luis
