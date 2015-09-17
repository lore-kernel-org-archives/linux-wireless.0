Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f52.google.com ([209.85.192.52]:34488 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbIQDjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 23:39:44 -0400
Message-ID: <1442461175.13630.20.camel@roni-HP> (sfid-20150917_054001_912326_2785AE6A)
Subject: Re: [PATCH v2 1/2] Staging: wilc1000: Use NULL instead of zero
From: Ronit Halder <ronit.crj@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com
Date: Thu, 17 Sep 2015 09:09:35 +0530
In-Reply-To: <20150917031541.GA8579@kroah.com>
References: <1442309698-12393-1-git-send-email-ronit.crj@gmail.com>
	 <20150915135424.GA29308@kroah.com>
	 <CAAm8cU6AvgQ5xYjbxZHd0bZ=sU6zwuqJYFbfC9VUF1YUh3AfxA@mail.gmail.com>
	 <20150917022207.GA1753@kroah.com> <1442458732.13630.14.camel@roni-HP>
	 <20150917031541.GA8579@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-16 at 20:15 -0700, Greg KH wrote:
> On Thu, Sep 17, 2015 at 08:28:52AM +0530, roni wrote:
> > Sorry for the ambiguity.
> > I am talking about my second patch in the series.
> > https://lkml.org/lkml/2015/9/15/293
> > 
> > > > None of the line edited in first patch haven't changed after that.
> > 
> > You applied the version 1 of the first patch in the series
> > https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=0e04f3f381c6a3ab3a7ef0ec9ded709e95996527
> > 
> > Since then those lines I changed in the patch mentioned above haven't
> > changed.
> > 
> > Why my second patch in this series doesn't apply?
> 
> I don't remember, that was many hundreds of patches ago, sorry.  Try it
> yourself to see if I messed up.  Perhaps someone else had already sent
> in that same change before you did?

git-apply shows no error if I apply second patch on
staging/staging-testing.

regards



