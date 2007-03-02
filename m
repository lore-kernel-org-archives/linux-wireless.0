Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:3386 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992577AbXCBQV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 11:21:58 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1338978nfa
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2007 08:21:57 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: rt2x00 updated in wireless-dev
Date: Fri, 2 Mar 2007 17:21:50 +0100
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
References: <20070302153116.GC6676@tuxdriver.com>
In-Reply-To: <20070302153116.GC6676@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703021721.50283.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 02 March 2007 16:31, John W. Linville wrote:
> I have applied the 30 or so patches Ivo sent to the linux-wireless
> list a couple of days ago. 

Thanks!

> Hopefully that brings the rt2x00 driver 
> in wireless-dev almost up-to-date?

Well the only patches that are not in are:
	- development stuff of today, which is still a bit buggy and not completed
	- software sequence support for rt2400pci/rt2500pci,
	  but that depends on the mac80211 patch that had been send earlier.
	- rfkill support patch. The last RFC I had send
	  out has not yet been replied, although Dmitry has send me a message
          he has seen the mail and will reply as soon as he has time.

> Via wireless-dev, the rt2x00 driver family is now in -mm and in
> Fedora rawhide, possibly elsewhere.  I think it will be best for all
> concerned to keep wireless-dev closely synchronized with rt2x00 fixes
> and developments.  I hope you agree.

I absolutely agree, unfortunately lack of time on my side prevented me often
to create those regular patches, although that is just a weak excuse since
I had made enough patches into rt2x00. ;)

> Ivo seems to have (almost!) mastered the patch posting process for
> upstream.  His last round of patches were easy to handle and merge.
> They would have been merged faster, if there weren't so many of them
> all at once.  A higher frequency of patches posted to linux-wireless
> will continue to improve the merge delay upstream.

Well like I mentioned in the patch mail, I have experimented a bit with git
this time. So hopefully there will be a git tree within a few weeks from where
you can pull new updates. :)

> The rt2x00 project is important to the upstream community, and hence
> to all the distros and their users.  I appreciate and applaud your
> efforts in bringing the rt2x00 driver family this far.  I hope you
> will now take the opportunity to more closely integrate your efforts
> with those of the greater linux-wireless community.

I'll do my best. :)

Ivo
