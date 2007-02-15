Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2166 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965534AbXBOOi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:38:59 -0500
Date: Thu, 15 Feb 2007 09:19:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: nl80211 userspace
Message-ID: <20070215141944.GA3310@tuxdriver.com>
References: <1171479846.3709.3.camel@johannes.berg> <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 15, 2007 at 10:17:50AM +0200, Nick Kossifidis wrote:
> I think it would be nice to have ifconfig for all interface
> configuration as they have done in openbsd, it's better to have one
> tool for all. What do you think ?

I think I'd lean to a separate tool, analagous to ethtool.

Anyway, the problem with using ifconfig is that it is generally
considered to be deprecated in favor of 'ip' (i.e. the iproute2
utility).  So increasing dependence on ifconfig would seem to be a
bad idea.

John

P.S.  Michael is, of course, right that the tool for users probably
should not rely on python (or perl, et al).  FWIW, I got the
impression that Johannes's tool was meant to use in the short-run
for developers...?
-- 
John W. Linville
linville@tuxdriver.com
