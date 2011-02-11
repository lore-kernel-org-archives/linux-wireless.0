Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60026 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab1BKQaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 11:30:14 -0500
Date: Fri, 11 Feb 2011 11:29:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: make use of slot time macros
Message-ID: <20110211162944.GD2224@tuxdriver.com>
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com>
 <4D553107.3020402@openwrt.org>
 <20110211161551.GA2224@tuxdriver.com>
 <4D5561F2.3050404@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4D5561F2.3050404@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 11, 2011 at 05:21:06PM +0100, Felix Fietkau wrote:
> On 2011-02-11 5:15 PM, John W. Linville wrote:
> > On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
> >> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
> >> > From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> >> > 
> >> > Instead of using raw numbers to assign slot time it would be better to
> >> > make use of predefined slot time macros
> >> How does this make it better?
> > 
> > Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
> Well, neither the unit of this variable, nor the values that can be used
> are ath9k specific.

True -- the patch is probably an unnecessarily zealous attempt to avoid
"magic numbers" in the code. :-)

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
