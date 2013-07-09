Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab3GIOK2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 10:10:28 -0400
Date: Tue, 9 Jul 2013 16:13:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Hendrik-Jan Heins <hjheins@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: intel 4965 fails to set channel 12 or 13
Message-ID: <20130709141312.GA3681@redhat.com> (sfid-20130709_161030_906697_56B43923)
References: <CAAU0D9dyrsHKw6cvbfNnhodQOC9_Bhxm0xiDqmKXTuN8Lby3DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAU0D9dyrsHKw6cvbfNnhodQOC9_Bhxm0xiDqmKXTuN8Lby3DQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 09, 2013 at 10:47:37AM +0200, Hendrik-Jan Heins wrote:
> Dear list,
> 
> On Debian Wheezy, kernel 3.2, I am trying to get my iwl4965 to
> scan/find/connect on channels 13 and 13. As I am in Europe, this
> should be no issue.
> However: I can not get these channels activated on my card at all!
> I tried the following:
> - Using the regdom option, setting to EU, DE, or PL (I see the correct
> setting in /sys/modules/cfg80211/parameters/ieee_regdom...
> - Completely disabling CRDA, and manually loading regdom through iw
> reg set EU/DE/PL/US
> 
> In all cases, I see some changes in the channels listed, but I never
> get 12 and 13 enabled.
> 
> Does anyone has an idea on this?

Please provide output of "iw phy" and "iw dev wlan0 scan".

Stanislaw
