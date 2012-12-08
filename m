Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posteo.de ([89.146.220.134]:48685 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab2LHWie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 17:38:34 -0500
Date: Sat, 8 Dec 2012 23:35:09 +0100
From: Felix Janda <felix.janda@posteo.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
Message-ID: <20121208223509.GA21258@gauss> (sfid-20121208_233838_434660_79B327DA)
References: <50C01558.8050102@lwfinger.net>
 <20121208143032.GA1903@gauss>
 <50C375BE.9050907@lwfinger.net>
 <20121208175615.GA10664@gauss>
 <50C399A9.2060304@lwfinger.net>
 <20121208202435.GA14973@gauss>
 <50C3AF0C.8000607@lwfinger.net>
 <20121208214157.GA21034@gauss>
 <50C3BD0F.1050603@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50C3BD0F.1050603@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/08/12 at 04:19pm, Larry Finger wrote:
> > Now I have a wlan0. Haven't tested it though yet. dmesg still prints some errors.
> 
> That is not an error - I just left a diagnostic in the code. Please let me know 
> if it works. It should as we only touched the firmware loading.
> 
> Is it OK if I use a "Reported-and-Tested by: <you>?
> 
> Larry

It's OK. Over christmas I'll do some thoroughful testing.

The delay of 60 seconds will stay?

Felix
