Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757201AbZLOVoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 16:44:13 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 13:44:13 -0800
Date: Tue, 15 Dec 2009 13:44:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?utf-8?B?THVrw6HFoQ==?= Turek <8an@praha12.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/5] nl80211: Add new WIPHY attribute
 COVERAGE_CLASS
Message-ID: <20091215214406.GB2067@tux>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
 <20091215190051.GC2123@tux>
 <20091215190248.GE2123@tux>
 <200912152207.33024.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <200912152207.33024.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 01:07:32PM -0800, Lukáš Turek wrote:
> On 15.12.2009 20:02 you wrote:
> > And if your IBSS and the AP already sent the coverage class through the
> > country IE I am not sure if we should allow overriding it.
> Overriding the coverage class is harmless, it won't allow you to break any 
> laws like overriding regulatory domain does.

I'm not concerned about how you override it, I am concerned about
creating consistancy though and avoiding tweaks through userspace
which can screw things. I'll address this in more details in the other
threads.

  Luis
