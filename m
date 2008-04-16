Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:39365 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbYDPVWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 17:22:11 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Wed, 16 Apr 2008 14:22:09 -0700
Message-ID: <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> (sfid-20080416_222226_469882_9FC73C4C)
In-Reply-To: <1208376292.27708.3.camel@localhost.localdomain>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org>   <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Dan Williams" <dcbw@redhat.com>,
	"Marcus Furlong" <furlongm@hotmail.com>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, April 16, 2008 1:05 PM, Dan Williams  wrote:

> On Wed, 2008-04-16 at 20:48 +0100, Marcus Furlong wrote:
>> On Wednesday 16 April 2008 20:01 in
> <fu5iel$c45$1@ger.gmane.org>, Marcus
>> Furlong wrote:
>> 
>>> On Wednesday 16 April 2008 19:28 in
>>> 
>> 
> <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.in
tel.com>,
>>> Chatre, Reinette wrote:
>>> 
>>>> Looks like the device is being brought up and down a lot ... are
>>>> you perhaps running wpa_supplicant or some other user application
>>>> that is doing this? Could you please give more information about
>>>> what you were doing when these errors started to appear?
>>> 
>>> Yes, wpa_supplicant is running as part of the boot process. Should
>>> I use some other application? (Do wireless-tools support WPA?) Or
>>> should I just load the module on it's own and give the dmesg output
>>> from that? 
>> 
>> Here is the output from the module loading without wpa_supplicant,
>> then me reloading it with debug flags, and running ifconfig wlan0
>> and iwlist scanning. Still some Microcode SW and FW errors in there,
>> but there's a lot less noise. 
>> 
>> 
> https://www.cs.tcd.ie/~furlongm/iwlwifi/iwl3945-output-no-wpasu
> pplicant.bz2 
> 
> Interesting; can you run wpa_supplicant again but dump it's detailed
> output using "-dddt" for us so we can see what it's doing and if it's
> causing the restarts? 

The driver itself is responsible for many of the restarts because of the
firmware errors. A wpa_supplicant log will still be useful. 

Could you please give more information about what the system is trying
to do here? In the first log you sent most failures appear to occur when
A band channels are configured ... does this match with what you are
trying to do? Can you explain why the BSSID is all zeroes? 

Thanks

Reinette
