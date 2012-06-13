Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46629 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2FMPjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 11:39:41 -0400
Received: by yhmm54 with SMTP id m54so644950yhm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 08:39:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339576294.4519.17.camel@jlt3.sipsolutions.net>
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
	<1339180580.5748.32.camel@jlt3.sipsolutions.net>
	<1339180948.5748.35.camel@jlt3.sipsolutions.net>
	<1339182289.5748.36.camel@jlt3.sipsolutions.net>
	<1339576294.4519.17.camel@jlt3.sipsolutions.net>
Date: Wed, 13 Jun 2012 17:39:39 +0200
Message-ID: <CAHsu+b9soGKgZmqWLU=-v0zOG0v_Arf8DFoCn1EQ7-86Mg_CdQ@mail.gmail.com> (sfid-20120613_173944_752171_9D74F484)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 13, 2012 at 10:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 21:04 +0200, Johannes Berg wrote:
>
>> Ahrg, b43 only sets fw.opensource too late ... this moves it:
>> http://p.sipsolutions.net/00c0056dc206e247.txt
>
> Has anyone tested this?

Sorry, missed that one.
I get this crash with that patch: http://i.imgur.com/2CMzA.png
