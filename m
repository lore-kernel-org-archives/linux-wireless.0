Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:50135 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbYDSNoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2008 09:44:02 -0400
Received: from X61.NetworkingUnlimited.com
 (ool-43503a0c.dyn.optonline.net [67.80.58.12]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JZK003Z9RHCXR20@mta1.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 19 Apr 2008 09:44:00 -0400 (EDT)
Date: Sat, 19 Apr 2008 09:44:01 -0400
From: Vincent C Jones <v.jones@networkingunlimited.com>
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
In-reply-to: <1208610565.26186.17.camel@johannes.berg>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
Message-id: <1208612641.3980.31.camel@X61.NetworkingUnlimited.com> (sfid-20080419_144420_984870_5D57E1D6)
MIME-version: 1.0
Content-type: text/plain
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
> hidden network, your laptop will be broadcasting the SSID in probe
> requests every time it scans, no matter where you are, even if you've
> moved across the continent?

I am not going to waste bandwidth debating the correctness of the PCI
guidelines, because right or wrong, they are what they are. I was just
trying to point out that the need to deal with access points which do
not broadcast their SSIDs is real and likely to become more common in
the future, at least for any systems using wireless in a retail or other
credit card dealing environment.

I'll leave it up to you (collective you, not necessarily a personal
you), how to best deal with associating with APs which are not
broadcasting their SSIDs. I agree with you (personal you this time) that
roaming around the country broadcasting those SSIDs does not seem
particularly desirable. So how should the ability to connect to non SSID
broadcasting APs be implemented? 

My hope is that the more you are aware of the constraints on others who
want to take advantage of all your hard work, the more likely you are to
make the correct decisions and trade offs. I am not attacking your
efforts, ability or motivation. I only wanted to point out that the
design assumption in the first quotation that "hidden SSIDs are so
uncommon" may need to be revised.
-- 
Vincent C Jones <v.jones@networkingunlimited.com>
Networking Unlimited, Inc.
