Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46666 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbDQLVd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 07:21:33 -0400
Message-ID: <1429269686.1885.0.camel@sipsolutions.net> (sfid-20150417_132136_852476_90481F7A)
Subject: Re: [PATCH] cfg80211: allow the plink state blocking for user
 managed mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Date: Fri, 17 Apr 2015 13:21:26 +0200
In-Reply-To: <CAEFj986ZH3mUMNR8O_kzrBhQA2ozFKav46Enc6ru4JUTX=qC7g@mail.gmail.com> (sfid-20150416_115328_531730_F5482B5A)
References: <1429161337-32680-1-git-send-email-yeohchunyeow@gmail.com>
	 <1429176257.1842.1.camel@sipsolutions.net>
	 <CAEFj986ZH3mUMNR8O_kzrBhQA2ozFKav46Enc6ru4JUTX=qC7g@mail.gmail.com>
	 (sfid-20150416_115328_531730_F5482B5A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-04-16 at 17:53 +0800, Yeoh Chun-Yeow wrote:
> On Thu, Apr 16, 2015 at 5:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2015-04-16 at 13:15 +0800, Chun-Yeow Yeoh wrote:
> >> User managed peering has no way to block the plink state
> >> for mesh peering setup by wpa_supp or authsae. Try to do
> >> allow this in kernel space, so that we can use iw utility
> >> to do that.
> >
> > I have no idea what you're trying to say here.
> >
> 
> wpa_supplicant and authsae allows us to do mesh peering in user space,
> but the plink state is still managed in kernel space.
> 
> But AFAIK, there is no implementation by wpa_supplicant or authsae to
> block the plink state.
> 
> By applying this patch, we can use the "iw mesh0 station set
> xx:xx:xx:xx:xx:xx plink_action block" to block the peer mesh STA. This
> is useful for experimenting purposes.

Can you please respin with a bit more detail in the commit log?

Thanks.

johannes

