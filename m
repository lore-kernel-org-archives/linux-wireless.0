Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab0D3RV3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:29 -0400
Date: Fri, 30 Apr 2010 10:57:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: fix supported rates IE if AP doesn't give
 us it's rates
Message-ID: <20100430105714.3d8cf84b@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <20100428203304.GB2912@tuxdriver.com>
References: <1272460624-3611-1-git-send-email-sgruszka@redhat.com>
	<1272460624-3611-2-git-send-email-sgruszka@redhat.com>
	<20100428133336.GA2527@dhcp-lab-161.englab.brq.redhat.com>
	<20100428203304.GB2912@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 28 Apr 2010 16:33:04 -0400
"John W. Linville" <linville@tuxdriver.com> wrote:

> > Please note these two patches together with "QoS fixes":
> > - mac80211: explicitly disable/enable QoS
> > - iwlwifi: manage QoS by mac stack
> > resolve:
> > https://bugzilla.redhat.com/show_bug.cgi?id=558002
> > 
> > "QoS fixes" alone resolve:
> > https://bugzilla.redhat.com/show_bug.cgi?id=539878
> > 
> > So I think we want all 4 patches in stable.
> > 
> > John,if possible push patches to Linus tree. When they lend there,
> > I will post backported patches to stable ML. I have them already
> > prepared ant tested for 2.6.32 :)
> 
> It is fairly late in the 2.6.34 cycle, and it isn't obvious to me
> that these fix any sort of regression.  Am I wrong?

If you count as regression bugs introduced in 2.6.34 development
cycle, these are not regression. Bugs are Fedora 12 regression over
Fedora 11, so most likely these bugs were introduced in 2.6.32
or 2.6.31 kernel. I have no strong filings to fix them fast, since
we have them unfixed for long time and not hear many complains. We
may fix them for Fedora now, and post to -stable after some more testing
and 2.6.34 release.

Cheers
Stanislaw
