Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:58558 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab1EIIZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 04:25:38 -0400
Received: by mail-ey0-f182.google.com with SMTP id 7so2066013eyg.41
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 01:25:29 -0700 (PDT)
Subject: Re: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1304929439.3475.10.camel@jlt3.sipsolutions.net>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
	 <1304600420-24227-2-git-send-email-coelho@ti.com>
	 <1304928720.3475.0.camel@jlt3.sipsolutions.net>
	 <1304929033.12586.447.camel@cumari>
	 <1304929439.3475.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 May 2011 11:25:26 +0300
Message-ID: <1304929526.12586.448.camel@cumari> (sfid-20110509_102542_169804_04A2D102)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-09 at 10:23 +0200, Johannes Berg wrote:
> On Mon, 2011-05-09 at 11:17 +0300, Luciano Coelho wrote:
> 
> > > Didn't you initially want to differentiate between SCAN_SSIDS and
> > > SSIDS_FILTER?
> > 
> > Yes, I'll add SSID filtering soon, as separate patches, if that's okay.
> > For now, the SSIDs that you can pass via nl80211 are used in the
> > probe_reqs.
> > 
> > We can also filter on RSSI, SNR and/or group results into one event.
> > This are other features that our firmware supports.  For now I have not
> > exposed this, but it could also be added to nl80211 in the future.
> 
> Ok, makes sense. However:
> 
> > + * struct cfg80211_sched_scan_request - scheduled scan request
> > description
> > + *
> > + * @ssids: SSIDs to report (other SSIDs will be filtered out)
> 
> That's wrong then, no?

Yes, you're right.  I'll fix this.

-- 
Cheers,
Luca.

