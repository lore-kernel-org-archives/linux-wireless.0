Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41869 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZCPKof (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 06:44:35 -0400
Date: Mon, 16 Mar 2009 11:44:33 +0100
From: Andreas Mohr <andi@lisas.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andreas Mohr <andi@lisas.de>, Bob Copeland <me@bobcopeland.com>,
	linville@tuxdriver.com, maximlevitsky@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 1/2] ath5k: support LEDs on Acer Aspire One netbook
Message-ID: <20090316104433.GA24968@rhlx01.hs-esslingen.de> (sfid-20090316_114438_030543_913887C8)
References: <1230840105-30960-1-git-send-email-me@bobcopeland.com> <20090111131015.GA31037@rhlx01.hs-esslingen.de> <20090111144227.GB13109@hash.localnet> <20090316100447.GA13819@rhlx01.hs-esslingen.de> <1237198577.27769.9.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237198577.27769.9.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Mar 16, 2009 at 11:16:17AM +0100, Johannes Berg wrote:
> On Mon, 2009-03-16 at 11:04 +0100, Andreas Mohr wrote:
> 
> > On Sun, Jan 11, 2009 at 09:42:27AM -0500, Bob Copeland wrote:
> > > > My LED is dead again on 2.6.29-rc1 (reason: doesn't contain this patch).
> > > 
> > > It's in wireless-testing, it just hasn't made it through the pipeline yet.
> > 
> > Just installed -rc8; would be truly sad to see this really small
> > but important patch (several million machines) not included in .29 proper...
> > (or would it later get merged via .29 -stable? Then I'm fine with it...)
> 
> I don't think "my LED doesn't blink" really counts as important...

Given that "NOTHING" (*) worked initially with this machine
which has been sold a couple million times, one could have the opinion
that ANY newly working component whatsoever counts...

Thanks,

Andreas Mohr

*):
- SD-card hotplug suspend/resume lockup
- SD-card filesystem _corruption_ after resume
- microphone in most cases not working due to suspected ALSA lib bug
- General Intel-HDA codec dodginess such as randomly toggling
  high noise level in speakers etc.
- X.org wrong dpi issues (now fixed, thanks!)
- X.org i915 suspend/resume lockup / VT switch issues (about to be fixed)
- ath5k suspend/resume issues (fixed)
- ath5k noise level calibration issues (fixed?)
- NetworkManager catastrophy (ongoing nerve corruption)
- libata performance loss down to UDMA/33 upon resume (fixed, (semi-)personally)
- Intel firmware module suspend/resume lockup (fixed, semi-personally)
- non-supported WLAN LED (would-be-fixed, semi-personally)
- flexible fan control not supported in-kernel (support in progress,
  thanks a lot!)
- suspected non-optimal SSD I/O scheduler support
- several very annoying CUPS non-working print issues,
  including an entirely locking-up interfacing to _ALL_ [suspected]
  HP JetDirect servers, whether builtin or not (fixed, semi-personally)
- and probably several others... (e.g. Ubuntu userspace bugs)

See also LKML monster thread "Bugs on aspire one A150"...
