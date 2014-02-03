Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36713 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaBCKJ6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 05:09:58 -0500
Message-ID: <1391422193.4488.2.camel@jlt4.sipsolutions.net> (sfid-20140203_111001_725883_589EDFEF)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Date: Mon, 03 Feb 2014 11:09:53 +0100
In-Reply-To: <CAB3XZEdmQzyYXYNh7=myKxDrqKCpZ+399a5QdvZcw8CrNd+Lwg@mail.gmail.com> (sfid-20140202_090417_527910_B21AB250)
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	 <1390810765.4251.0.camel@jlt4.sipsolutions.net>
	 <CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com>
	 <1390997834.4143.7.camel@jlt4.sipsolutions.net>
	 <1390998668.4143.8.camel@jlt4.sipsolutions.net>
	 <CAB3XZEdmQzyYXYNh7=myKxDrqKCpZ+399a5QdvZcw8CrNd+Lwg@mail.gmail.com>
	 (sfid-20140202_090417_527910_B21AB250)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-02-02 at 10:04 +0200, Eliad Peller wrote:

> i referred to this:
> 
>  * @match_sets: sets of parameters to be matched for a scan result
>  * entry to be considered valid and to be passed to the host
>  * (others are filtered out).
>  * If ommited, all results are passed.
> 
> it should probably mention the empty-ssid case as well.

Well, hmm, that part seems fine, maybe the documentation for struct
cfg80211_match_set should say that the SSID can be blank/zero length.


johannes

