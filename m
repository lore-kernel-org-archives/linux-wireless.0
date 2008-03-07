Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51729 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411AbYCGSRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 13:17:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Vladimir Koutny <vlado@work.ksp.sk>
Subject: Re: 2.6.24, mac80211 and b/g switching
Date: Fri, 7 Mar 2008 19:16:28 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <47D160E4.3040503@work.ksp.sk> <1204909966.6387.31.camel@johannes.berg> <47D17EDF.4010100@work.ksp.sk>
In-Reply-To: <47D17EDF.4010100@work.ksp.sk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803071916.28776.mb@bu3sch.de> (sfid-20080307_181709_157350_9EFB1831)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 March 2008 18:43:59 Vladimir Koutny wrote:
> Johannes Berg wrote:
> >> Is this a known issue? (I didn't manage to find anything in ml archives
> >> so far) Or any hints on how to solve this?
> > 
> > You want to develop against a non-ancient kernel that has all the HW
> > mode foo removed.
> 
> Well, the question is not what version I would like to develop for, but
> what version I have to :( Stable kernel releases should be those
> versions you want to base real products on, right?
> 
> Do you think that taking mac80211 from wireless-2.6 (or -testing or
> whatever) would cause way too many conflicts when merged back to 2.6.24?
>   Or am I on my own to fix this somehow in 2.6.24?

OpenWRT ported a rather recent mac80211 back to 2.6.23. So it shouldn't be too hard.

-- 
Greetings Michael.
