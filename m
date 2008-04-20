Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYDTP2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 11:28:06 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vincent C Jones <v.jones@networkingunlimited.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1208610565.26186.17.camel@johannes.berg>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1208608786.3980.7.camel@X61.NetworkingUnlimited.com>
	 <1208610565.26186.17.camel@johannes.berg>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 11:24:17 -0400
Message-Id: <1208705057.5036.7.camel@localhost.localdomain> (sfid-20080420_162825_434793_161188A3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-04-19 at 15:09 +0200, Johannes Berg wrote:
> > > Does anybody actually *want* that? I personally dislike the behaviour
> > > of scanning for all previously known SSIDs actively when hidden SSIDs
> > > are so uncommon, I see it as an information disclosure vulnerability.
> > 
> > I can't speak for what others may want, but the Payment Card Industry
> > security guidelines include not broadcasting the SSID as one of their
> > requirements, if that is what you mean by "hidden SSIDs." 
> 
> So how would you feel if I told you that, after you have once used that
> hiddent network, your laptop will be broadcasting the SSID in probe
> requests every time it scans, no matter where you are, even if you've
> moved across the continent?

Unfortuately, I keep getting way too many reports about hidden SSIDs
still.  I don't feel like it's something we can start ignoring (yet).
Maybe in a few years, but we've still got to handle this for the
forseeable future.

Dan


