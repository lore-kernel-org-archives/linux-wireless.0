Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbXIYSaT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:30:19 -0400
Subject: Re: ath5k and network manager
From: Dan Williams <dcbw@redhat.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: linux-wireless@vger.kernel.org, networkmanager-list@gnome.org
In-Reply-To: <46F296D8.3090704@debian.org>
References: <20070919214007.1a6a9b4a@freepuppy.rosehill>
	 <43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com>
	 <200709201511.23400.mb@bu3sch.de>  <46F296D8.3090704@debian.org>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:27:44 -0400
Message-Id: <1190744864.27777.25.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-20 at 18:50 +0300, Faidon Liambotis wrote:
> [CCing networkmanager mailing list]
> Michael Buesch wrote:
> > On Thursday 20 September 2007, Luis R. Rodriguez wrote:
> >> On 9/20/07, Stephen Hemminger <shemminger-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> >>> Network manager doesn't seem to detect ath5k. Perhaps it is because
> >>> it is name "ath0".  I think device should follow the convention of using
> >>> name "wifi0" rather than BSD convention of putting driver name in device name.
> >> I couldn't agree anymore. But my ath5k kicks out a wlan%d name as with
> >> any other mac80211 driver. Is yours coming out to ath%d ?
> > 
> > Probably udev renames it.
> IMHO, NetworkManager should cope with whatever name is assigned to a device.
> AFAIK, device names are only "suggestions" by the drivers; the user may
> rename the device name (either by "ip link set name", with ifrename or
> with udev rules) to his liking, e.g. home.

0.7 svn trunk uses device indexes internally already.

> Granted, seems a bit of an overkill to rename a device on a machine
> where NetworkManager is in charge of the device but still, there is no
> reason why it shouldn't be allowed.

No reason why you shouldn't be able to do this with NM.

Dan

> Regards,
> Faidon
> _______________________________________________
> NetworkManager-list mailing list
> NetworkManager-list@gnome.org
> http://mail.gnome.org/mailman/listinfo/networkmanager-list

