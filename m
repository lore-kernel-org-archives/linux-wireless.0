Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-out.forthnet.gr ([193.92.150.103]:30837 "EHLO
	mx-out-04.forthnet.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207AbXITQYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:24:30 -0400
Message-ID: <46F296D8.3090704@debian.org>
Date: Thu, 20 Sep 2007 18:50:48 +0300
From: Faidon Liambotis <paravoid@debian.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: networkmanager-list@gnome.org
Subject: Re: ath5k and network manager
References: <20070919214007.1a6a9b4a@freepuppy.rosehill> <43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com> <200709201511.23400.mb@bu3sch.de>
In-Reply-To: <200709201511.23400.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[CCing networkmanager mailing list]
Michael Buesch wrote:
> On Thursday 20 September 2007, Luis R. Rodriguez wrote:
>> On 9/20/07, Stephen Hemminger <shemminger-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>>> Network manager doesn't seem to detect ath5k. Perhaps it is because
>>> it is name "ath0".  I think device should follow the convention of using
>>> name "wifi0" rather than BSD convention of putting driver name in device name.
>> I couldn't agree anymore. But my ath5k kicks out a wlan%d name as with
>> any other mac80211 driver. Is yours coming out to ath%d ?
> 
> Probably udev renames it.
IMHO, NetworkManager should cope with whatever name is assigned to a device.
AFAIK, device names are only "suggestions" by the drivers; the user may
rename the device name (either by "ip link set name", with ifrename or
with udev rules) to his liking, e.g. home.

Granted, seems a bit of an overkill to rename a device on a machine
where NetworkManager is in charge of the device but still, there is no
reason why it shouldn't be allowed.

Regards,
Faidon
