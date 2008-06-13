Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:30099 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbYFMOAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 10:00:03 -0400
Received: from poczta.interia.pl (mi06.poczta.interia.pl [10.217.12.6])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id 29A8131AB48
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 16:00:01 +0200 (CEST)
Received: from [192.168.1.7] (d90-129-241-239.cust.tele2.pl [90.129.241.239])
	by poczta.interia.pl (INTERIA.PL) with ESMTP id 36A7C1324BC
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 16:00:00 +0200 (CEST)
Message-ID: <48527D72.4070509@interia.pl> (sfid-20080613_160009_672821_EF7EE62A)
Date: Fri, 13 Jun 2008 16:00:18 +0200
From: Maciek Kaliszewski <mkalkal@interia.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
References: <4852658A.4040402@interia.pl> <20080613132317.GB5333@tuxdriver.com> <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>
In-Reply-To: <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry I've sent it off-list. resent
Tomas Winkler wrote:
> On Fri, Jun 13, 2008 at 4:23 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>   
>> On Fri, Jun 13, 2008 at 02:18:18PM +0200, Maciek Kaliszewski wrote:
>>     
>>> I cannot connect to my WIFI/WPA network using iwl3945 driver.
>>>       
>> Any chance that adding a line like this in /etc/modprobe.conf is
>> helpful?
>>
>>        options iwl3945 disable_hw_scan=1
>>
>> Worth a shot... :-)
>>
>>     
> I would suggest to upgrade supplicant as iwlist is apparently working
>   
debian:/home/u# rmmod iwl3945.ko
debian:/home/u# insmod
/lib/modules/2.6.24.2/updates/drivers/net/wireless/iwlwifi/iwl3945.ko
disable_hw_scan=1

The same results with wpa_supplicant.

debian:/home/u# dpkg -l |grep wpa
ii  wpasupplicant                        0.6.3-1
Client support for WPA and WPA2 (IEEE 802.11

It is standard debian/lenny package .
Should I compile wpa_supplicant from source ?

On other computer debian/lenny also ,and p54pci.ko driver everything
works ok.

Regards
Maciek Kaliszewski





----------------------------------------------------------------------
Mieszkasz w USA? Zobacz portal dla Polonii!
kliknij >>> http://link.interia.pl/f1e36

