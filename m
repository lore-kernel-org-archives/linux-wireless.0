Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775AbbIDSZQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 14:25:16 -0400
Message-ID: <1441391108.1971.17.camel@sipsolutions.net> (sfid-20150904_202520_218791_72C1FE61)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Fri, 04 Sep 2015 20:25:08 +0200
In-Reply-To: <wrfjmvx2gi0m.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <wrfjvbbsp6ot.fsf@redhat.com> <1441275474.2565.18.camel@sipsolutions.net>
	 <wrfjmvx2gi0m.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I'll add a comment to the code explaining why it is done this way. I 
> had
> a peak at the rate_control code earlier, but it wasn't obvious to me
> whether I should be using that API at all. Is there an explanation of
> the API and it's usage somewhere?
> 

Sadly no, it's one of the oldest and in a way cruftiest parts of the
code, though it has seen a fair share of modernisation :)

johannes
