Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbaDIHpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 03:45:14 -0400
Message-ID: <1397029496.4964.0.camel@jlt4.sipsolutions.net> (sfid-20140409_094521_783470_028BBBD4)
Subject: Re: ath10k: ieee80211_restart_work called with hardware scan in
 progress
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 09 Apr 2014 09:44:56 +0200
In-Reply-To: <53446607.1060609@candelatech.com> (sfid-20140408_231213_154583_EA8ACCB7)
References: <53399E42.2090504@candelatech.com>
	 <CA+BoTQmfBGJxwFnpq+7dE7MgL_db5gkCvRVfhk9YFAAPLZQwHQ@mail.gmail.com>
	 <53446607.1060609@candelatech.com> (sfid-20140408_231213_154583_EA8ACCB7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-08 at 14:11 -0700, Ben Greear wrote:
> On 03/31/2014 10:32 PM, Michal Kazior wrote:
> > On 31 March 2014 18:56, Ben Greear <greearb@candelatech.com> wrote:
> >> This came from a customer (demo) system.  Firmware is 10.1.389 based, modified
> >> by us.  It has lots of known issues, but I haven't seen the warning
> >> below before, and not sure it is specifically a bug with ath10k or not.
> > 
> > Hmm..
> 
> We are seeing crashes that are probably related to this fairly often.
> 
> Johannes:  Do you have any suggestion as to how to go about fixing this?

Abort the hw scan properly before calling hw restart.

johannes

