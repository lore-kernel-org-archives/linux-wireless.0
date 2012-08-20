Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37173 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2HTQBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 12:01:39 -0400
Message-ID: <1345478494.4459.30.camel@jlt3.sipsolutions.net> (sfid-20120820_180155_448403_48417B1D)
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 20 Aug 2012 18:01:34 +0200
In-Reply-To: <50325D89.9080209@lwfinger.net> (sfid-20120820_175351_872841_14CD8D92)
References: <502D0C72.2050207@lwfinger.net>
	  (sfid-20120816_170635_404509_F239FBF6) <1345459509.4459.5.camel@jlt3.sipsolutions.net>
	 <50325D89.9080209@lwfinger.net> (sfid-20120820_175351_872841_14CD8D92)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-20 at 10:53 -0500, Larry Finger wrote:

> I'm still concerned about the bigger picture. I can understand that the -5 
> version was experimental, but why was a driver released that needed a firmware 
> version that could never be obtained? If any driver version needs a particular 
> firmware, the fw must be available as long as anyone might be using that driver. 
> To me, that means forever.

Well, yes. That firmware, however, never was never available publicly.
The fact that the driver was released anyway is due to us working on the
driver upstream while working with the experimental internal firmware.

johannes

