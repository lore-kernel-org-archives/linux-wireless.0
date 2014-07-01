Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57601 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbaGAPKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 11:10:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1X1zh6-0002ua-9K
	for linux-wireless@vger.kernel.org; Tue, 01 Jul 2014 17:10:04 +0200
Received: from 67-3-189-166.omah.qwest.net ([67.3.189.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 17:10:04 +0200
Received: from nmschulte by 67-3-189-166.omah.qwest.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2014 17:10:04 +0200
To: linux-wireless@vger.kernel.org
From: Nathan Schulte <nmschulte@gmail.com>
Subject: Re: [ath9k-devel] Bug: USB wifi card TL-WN722N (AR9271, =?utf-8?b?YXRoOWtfaHRjKQ==?= fails to get DHCP lease
Date: Tue, 1 Jul 2014 04:41:25 +0000 (UTC)
Message-ID: <loom.20140701T064007-256@post.gmane.org> (sfid-20140701_171010_457597_CE37CFAB)
References: <CAMtVo_MxCfV7MWC+ksWc=PJM0KEHDUVuCMpg0NCWBW8EeLU5Jw@mail.gmail.com>	<53AF5FB8.3060505@lwfinger.net>	<CAMtVo_PAkxCkxO7ETV6r=Xg75LLRt0GHi8GdqhT4tXKZSpmOvQ@mail.gmail.com>	<53B047F7.2000204@lwfinger.net>	<CAMtVo_NLnfDsYrcf7_Pzt47WyMexkzuZuUREYhoKC2F8ZyfXzQ@mail.gmail.com> <20140630142007.GA29198@tuxdriver.com> <53B19D6B.2030601@rempel-privat.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@...> writes:
> i would prefer to wait for correct git bisect results.
>  <at> lolilolicon did you tried "git bisect start v3.14 v3.15" instead of
> your restricted variant?

You may find it useful to read this part of the git manual regarding 
bisection and merge commits:

https://www.kernel.org/pub/software/scm/git/docs/user-manual.html#bisect-
merges

I hope this is helpful and not just noise!

--
Nate

