Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbbIQDPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 23:15:42 -0400
Date: Wed, 16 Sep 2015 20:15:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: roni <ronit.crj@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com,
	linux-wireless@vger.kernel.org, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH v2 1/2] Staging: wilc1000: Use NULL instead of zero
Message-ID: <20150917031541.GA8579@kroah.com> (sfid-20150917_051557_076842_AC064023)
References: <1442309698-12393-1-git-send-email-ronit.crj@gmail.com>
 <20150915135424.GA29308@kroah.com>
 <CAAm8cU6AvgQ5xYjbxZHd0bZ=sU6zwuqJYFbfC9VUF1YUh3AfxA@mail.gmail.com>
 <20150917022207.GA1753@kroah.com>
 <1442458732.13630.14.camel@roni-HP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442458732.13630.14.camel@roni-HP>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 08:28:52AM +0530, roni wrote:
> Sorry for the ambiguity.
> I am talking about my second patch in the series.
> https://lkml.org/lkml/2015/9/15/293
> 
> > > None of the line edited in first patch haven't changed after that.
> 
> You applied the version 1 of the first patch in the series
> https://git.kernel.org/cgit/linux/kernel/git/gregkh/staging.git/commit/?h=staging-testing&id=0e04f3f381c6a3ab3a7ef0ec9ded709e95996527
> 
> Since then those lines I changed in the patch mentioned above haven't
> changed.
> 
> Why my second patch in this series doesn't apply?

I don't remember, that was many hundreds of patches ago, sorry.  Try it
yourself to see if I messed up.  Perhaps someone else had already sent
in that same change before you did?

thanks,

greg k-h
