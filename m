Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbaAVMep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 07:34:45 -0500
Message-ID: <1390394079.4334.30.camel@jlt4.sipsolutions.net> (sfid-20140122_133448_473124_07B17A6E)
Subject: Re: [PATCH] mac80211: send {add,del}ba on AC_VO like other mgmt
 frames, as per spec
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Wed, 22 Jan 2014 13:34:39 +0100
In-Reply-To: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com> (sfid-20140122_125351_404061_6DF7DBAB)
References: <1390391564-18481-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20140122_125351_404061_6DF7DBAB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm. I guess you're right about the spec, but I vaguely remember races
in this with the delBA going out too soon or so?

johannes

