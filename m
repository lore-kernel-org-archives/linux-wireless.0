Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3HWHuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 03:50:07 -0400
Message-ID: <1377244202.14021.9.camel@jlt4.sipsolutions.net> (sfid-20130823_095019_200111_F83566F3)
Subject: Re: [RFC] mac80211: fix locking with ieee80211_resume_disconnect()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Aug 2013 09:50:02 +0200
In-Reply-To: <CAB3XZEexJ28291uKi=0tPvsORHQinbc272KRe2m=Zr6_CV3vFA@mail.gmail.com> (sfid-20130822_233758_032490_3A4ABD6E)
References: <1377117341-9327-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEexJ28291uKi=0tPvsORHQinbc272KRe2m=Zr6_CV3vFA@mail.gmail.com>
	 (sfid-20130822_233758_032490_3A4ABD6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 00:37 +0300, Eliad Peller wrote:

> can't you simply add a new rtnl-locked interface iterator?

Hmm, yeah, I guess that would be simpler :)

johannes

