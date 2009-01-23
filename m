Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:48881 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZAWFcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:32:36 -0500
Received: by wf-out-1314.google.com with SMTP id 27so5370027wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 21:32:36 -0800 (PST)
Subject: Re: iwl3945 regression: associates but no data is transfered
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: samuel@sortiz.org, "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <4979077B.8090804@lwfinger.net>
References: <87priffb95.fsf@litku.valot.fi>
	 <20090122183448.GC3646@tuxdriver.com>
	 <d7a260e8d188b785d0d2be743c8c5461@localhost>
	 <4979077B.8090804@lwfinger.net>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 21:32:34 -0800
Message-Id: <1232688754.9701.86.camel@brick> (sfid-20090123_063243_344676_4E623D10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-01-22 at 17:55 -0600, Larry Finger wrote:
> samuel@sortiz.org wrote:
> 
> > The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, which
> > is not iwlwifi related.
> > Even though it's an mlme commit, it doesnt seem to affect other drivers (at
> > least b43 and ath5k).
> > I'll come up soon with a proper fix, but for now iwl3945 users should
> > revert that commit locally.
> 
> Something between 2.6.29-rc1 and -rc2 killed b43 and p54usb on my WPA2 network. My rtl8187
> devices work fine.
> 
> I'm in the process of bisecting right now. Only 1500 commits to go.

I wish I'd said something sooner, I thought it was just the university's network
being particularly crappy causing wpa2 to be so flaky since going to -rc2. (b43)

Harvey



