Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:23227 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbbEUG2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 02:28:51 -0400
Date: Thu, 21 May 2015 11:58:34 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] nl80211: Add support to configure low ack threshold
Message-ID: <20150521062828.GA4935@qca.qualcomm.com> (sfid-20150521_082854_422352_7567FC1E)
References: <1431600456-10697-1-git-send-email-rmanohar@qti.qualcomm.com>
 <1432020579.7437.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1432020579.7437.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 09:29:39AM +0200, Johannes Berg wrote:
> On Thu, 2015-05-14 at 16:17 +0530, Rajkumar Manoharan wrote:
> > Add a new nl80211 attribute to configure low ack threshold (number of
> > consecutive frames) not being acked by station. This threshold is used
> > to kickout station by driver through low ack event. This allows user to
> > tune the parameter to improve robustness under noisy environment.
> 
> If we're making this configurable, why not allow it to be done per
> station?
>
Though per-STA config looks granular, does it look good to have
different threshold for each station within the same BSS? On what basis
threshold will be defined for each station?

Please share your comments.

-Rajkumar
