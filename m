Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:50293 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbYCaWC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 18:02:29 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1015394rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 15:02:29 -0700 (PDT)
Message-ID: <183c1cc10803311502u1ae78f5cme9e05f0100c4a10f@mail.gmail.com> (sfid-20080331_230232_669829_9B19EBF1)
Date: Mon, 31 Mar 2008 18:02:29 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with iwl4965 and kernel 2.6.24.4
In-Reply-To: <D936D925018D154694D8A362EEB08920040FA1C9@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803262027k4c40386v767b2f9c79945deb@mail.gmail.com>
	 <183c1cc10803270741r66896d88q15614af05a4142e6@mail.gmail.com>
	 <D936D925018D154694D8A362EEB08920040BC0B8@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803301935p16647709u837f3fb3377c687d@mail.gmail.com>
	 <D936D925018D154694D8A362EEB08920040FA1C9@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 31, 2008 at 4:40 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
> On Sunday, March 30, 2008 7:35 PM, John Goulah  wrote:
>
>  > Let me know where to go from here; if you still want the
>  > wpa_supplicant info I can post a bug for that, but the more major
>  > problem seems that I have to explicitly tell iwconfig what my AP mac
>  > address is, it wont associate otherwise even though "iwlist scan"
>  > turns it up just fine, but I'm not having much luck producing useful
>  > info here.
>
>  It is not clear how you are associating. Are you using wpa_supplicant or
>  iwconfig? Please submit a bug with the details of your setup and steps
>  to associate. Please include the wpa_supplicant logs and the driver
>  logs.
>


I have to use both.  I have to use iwconfig to pick my essid and
access point, and I use wpa_supplicant to setup the encryption tunnel.
 Then I dhclient the IP address.    In previous wireless experience,
once I've set the essid , it automatically associates to the access
point (at least I can see that the MAC address is defined when I run
iwconfig).  That does not happen with this driver- only "Not
Associated" or "Invalid". Unfortunately debug for these cases isn't
spitting any info.  I've been setting my access point mac address
specifically with "iwconfig wlan0 ap <MAC>"   -before- running
wpa_supplicant since I thought I had to be associated before running
wpa_supplicant but it sounds like you are saying otherwise, so I'll
try that tonight and then submit my findings in a bug.   If something
I've said sounds completely wrong let me know.


Thanks,
John
