Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from brent.tribalogic.net ([78.86.109.144]:47901 "EHLO
	summit.brent.tribalogic.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754174Ab1EJJrQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 05:47:16 -0400
Message-ID: <4DC9072D.4030103@colin.guthr.ie> (sfid-20110510_114734_665854_E89D8059)
Date: Tue, 10 May 2011 10:36:45 +0100
From: Colin Guthrie <mageia@colin.guthr.ie>
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	Thomas Backlund <tmb@mageia.org>
Subject: Re: [Regression] Problem with rfkill on 2.6.38
References: <ip6j66$o5f$1@dough.gmane.org> <1304930195.3475.17.camel@jlt3.sipsolutions.net> <4DC81FC7.9040503@colin.guthr.ie> <20110509171144.GA7194@srcf.ucam.org>
In-Reply-To: <20110509171144.GA7194@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'Twas brillig, and Matthew Garrett at 09/05/11 18:11 did gyre and gimble:
> On Mon, May 09, 2011 at 06:09:27PM +0100, Colin Guthrie wrote:
> 
>> Just a quick (non-compile) followup from my last email... blacklisting
>> the dell-laptop module works around the issue, so I think the commit
>> previously mentioned is indeed the culprit (as it's the only recent
>> commit and does fiddle with the rfkill stuff).
>>
>> Not sure what the best track forward is, but it's certainly a
>> regression, so should probably be fixed or reverted until a more
>> complete fix is found.
> 
> If you can confirm that with a build then I'll do that.

ACK. Reverting that commit and unblacklisting the dell_laptop module
restores the previous, working functionality. I've flipped rfkill a few
times and it's always worked fine.

Many thanks.

Col


-- 

Colin Guthrie
mageia(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
  Mageia Contributor [http://www.mageia.org/]
  PulseAudio Hacker [http://www.pulseaudio.org/]
  Trac Hacker [http://trac.edgewall.org/]
