Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2865 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbXJPAjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 20:39:17 -0400
Date: Mon, 15 Oct 2007 19:47:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: John Daiker <daikerjohn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ath5k compile error in wireless-2.6.git
Message-ID: <20071015234748.GB4125@tuxdriver.com> (sfid-20071016_013920_118659_EDAC7F1F)
References: <4713EBCA.8010700@gmail.com> <20071015234601.GA4125@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071015234601.GA4125@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2007 at 07:46:01PM -0400, John W. Linville wrote:
> On Mon, Oct 15, 2007 at 03:38:02PM -0700, John Daiker wrote:
> > John,
> > 
> > I just checked out the wireless-2.6.git tree from Kernel.org to test the 
> > new ath5k driver. I get the following compile error on a 'vanilla' 
> > git-clone.
> 
> Please use the 'everything' branch for development.
> 
> 	git checkout everything

Hmmm...maybe this instead:

	git checkout -b everything origin/everything

John
-- 
John W. Linville
linville@tuxdriver.com
