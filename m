Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0KSR4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 12:56:01 -0500
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4CE68AF4.8060507@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>
	 <4CDDAA3B.9090007@candelatech.com>
	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>
	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
	 <4CE292F7.4090200@kernel.org>
	 <1289929258.3673.1.camel@jlt3.sipsolutions.net>
	 <4CE396A9.1050908@kernel.org>
	 <1290020005.3777.6.camel@jlt3.sipsolutions.net>
	 <4CE4C8DD.6010806@kernel.org> <51f5dd53c39a77fff4efc1a99b189725@localhost>
	 <4CE4D41F.1080005@kernel.org>
	 <1290099585.3801.1.camel@jlt3.sipsolutions.net>
	 <4CE68AF4.8060507@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:57:32 -0800
Message-ID: <1290189452.3768.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 15:34 +0100, Tejun Heo wrote:

> Awesome.  :-)
> 
> Ben, if you have trouble generating full trace, please let me know if
> there's something I can buy which isn't too expensive to reproduce the
> problem.  I would be happy to track it down myself.

Maybe you can try Ben's setup in kvm (or directly on your box if you
like) with mac80211_hwsim. From a mac80211 POV it should be almost
equivalent, although it'll do different memory allocation patterns etc.

johannes

