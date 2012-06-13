Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59669 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2FMIbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 04:31:38 -0400
Message-ID: <1339576294.4519.17.camel@jlt3.sipsolutions.net> (sfid-20120613_103146_641771_26DBE2E9)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andre Heider <a.heider@gmail.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Wed, 13 Jun 2012 10:31:34 +0200
In-Reply-To: <1339182289.5748.36.camel@jlt3.sipsolutions.net> (sfid-20120608_210507_564049_E7275D9F)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	 <1339136879.5832.1.camel@jlt3.sipsolutions.net>
	 <1339137689.5832.2.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	 <1339167160.4901.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	 <1339168452.5748.0.camel@jlt3.sipsolutions.net>
	 <1339168600.5748.2.camel@jlt3.sipsolutions.net>
	 <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	 <4FD21C6B.5000402@lwfinger.net>
	 <1339170182.5748.7.camel@jlt3.sipsolutions.net>
	 <1339170287.5748.8.camel@jlt3.sipsolutions.net>
	 <1339170510.5748.9.camel@jlt3.sipsolutions.net>
	 <1339170742.5748.10.camel@jlt3.sipsolutions.net>
	 <CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	 <1339171159.5748.11.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	 <4FD22727.7000500@lwfinger.net>
	 (sfid-20120608_182415_948584_8403B5AF) <1339180580.5748.32.camel@jlt3.sipsolutions.net>
	 (sfid-20120608_203626_490471_92895C0D) <1339180948.5748.35.camel@jlt3.sipsolutions.net>
	 (sfid-20120608_204234_267803_1F940956) <1339182289.5748.36.camel@jlt3.sipsolutions.net>
	 (sfid-20120608_210507_564049_E7275D9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 21:04 +0200, Johannes Berg wrote:

> Ahrg, b43 only sets fw.opensource too late ... this moves it:
> http://p.sipsolutions.net/00c0056dc206e247.txt

Has anyone tested this?

johannes

