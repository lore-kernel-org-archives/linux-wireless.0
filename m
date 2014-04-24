Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaDXICm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 04:02:42 -0400
Message-ID: <1398326539.4154.0.camel@jlt4.sipsolutions.net> (sfid-20140424_100312_949622_2C6DBF08)
Subject: Re: iwlmvm: High latencies and low RX rate with firmware version
 22.24.8.0 but not with 22.1.7.0
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Thu, 24 Apr 2014 10:02:19 +0200
In-Reply-To: <87sip3b20f.fsf@nemi.mork.no> (sfid-20140424_094956_885901_C7CBD498)
References: <87sip3b20f.fsf@nemi.mork.no>
	 (sfid-20140424_094956_885901_C7CBD498)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-04-24 at 09:49 +0200, Bjørn Mork wrote:

> I realize that icmp echos don't necessarily tell the whole truth, but
> the same latency difference is noticable on e.g interactive ssh sessions
> as well.  So I believe pinging illustrates the difference pretty well.
> The *only* thing changed between these sessions is the iwl
> firmware. Position, channel, driver, hardware is the same. This was
> captured on 2.4GHz.

There might be differences in how the driver treats the firmware - I
think it probably turns off powersave for the older one. Have you tried
turning it off manually?

johannes

