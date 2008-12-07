Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:38657 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbYLGFQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 00:16:57 -0500
Received: by rv-out-0506.google.com with SMTP id k40so654185rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 21:16:56 -0800 (PST)
Message-ID: <b3153e950812062116q340c6b67l4d0c9a162d389cbf@mail.gmail.com> (sfid-20081207_061741_110236_A4FE6080)
Date: Sat, 6 Dec 2008 21:16:56 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228554333.15939.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1226915999.3599.33.camel@johannes.berg>
	 <1226933141.3902.19.camel@johannes.berg>
	 <1ba2fa240811170714j7d0daf5xe718ffa1d4de8f40@mail.gmail.com>
	 <1226942887.3902.30.camel@johannes.berg>
	 <1ba2fa240811170934u34fa6e28m1411715690fd24b9@mail.gmail.com>
	 <1226944799.3902.52.camel@johannes.berg>
	 <20081118194652.GD21772@tuxdriver.com>
	 <1ba2fa240811181508y633be12pd9f2f9bd0e2c81e4@mail.gmail.com>
	 <b3153e950812051553r2035b8aex4f54f6cf704a26b3@mail.gmail.com>
	 <1228554333.15939.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will be happy to help if extra help need it. below is the link to the bug.
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1845

On Sat, Dec 6, 2008 at 1:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-05 at 15:53 -0800, mohamed salim abbas wrote:
>> some bugs related to coming from resume is filed caused by removing
>> this callback function, any body looking into alternatives to share
>> how to fix this problem.
>
> Yes, in fact, somebody _is_ looking into implementing _proper_
> suspend/resume support. You'll either have to wait or help out.
>
> johannes
>
