Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13563 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393AbXHBMRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:17:35 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
Date: Thu, 2 Aug 2007 15:17:27 +0300
Message-ID: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
In-Reply-To: <46B1A0FF.4000504@gmail.com>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "dragoran" <drago01@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: "Dan Williams" <dcbw@redhat.com>, <linux-wireless@vger.kernel.org>,
	"network manager" <networkmanager-list@gnome.org>,
	<ipw3945-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>-----Original Message-----
>From: ipw3945-devel-bounces@lists.sourceforge.net
[mailto:ipw3945-devel-
>bounces@lists.sourceforge.net] On Behalf Of dragoran
>Sent: Thursday, August 02, 2007 12:17 PM
>To: Johannes Berg
>Cc: Dan Williams; linux-wireless@vger.kernel.org; network manager;
ipw3945-
>devel@lists.sourceforge.net
>Subject: Re: [ipw3945-devel] chaning mode only when interface down?
>
>Johannes Berg wrote:
>> On Thu, 2007-08-02 at 09:44 +0200, dragoran wrote:
>>
>>> I noticed that I have to do ifdown wlan0 before I can change the
mode
>>> with iwconfig.
>>> When I do it while the interface is up I get a error that the device
is
>>> busy.
>>>
>>
>> It is busy.
>>
>>
>ok
>>> It seems to happen with ad-hoc, master and back from them to
managed.
>>> Is this a bug in the iwlwifi driver or in mac80211 ?
>>>
>>
>> Neither, it is expected behaviour.
>ok thx for this info.
>>  Blame it on Jean that wireless
>> extensions are ill-defined and don't mandate this.
>>
>>
>>> Because of this NM can't create ad-hoc networks because it does it
while
>>> the device is up.
>>> Any ideas?
>>>
>>
>> Fix NM?
>>
>>
>Dan, something for you  ;)
>does NM knows if the driver is a mac80211 one?
>
>

There is a definitely a known issue in the driver that we still need to
resolve, but I agree with Johannes that there is a problem in design of
the configuration as well. 
Unfortunately as this is in lower priority on my list now it will take
few weeks till I get to solve this. 
 
Tomas
>-----------------------------------------------------------------------
--
>This SF.net email is sponsored by: Splunk Inc.
>Still grepping through log files to find problems?  Stop.
>Now Search log events and configuration files using AJAX and a browser.
>Download your FREE copy of Splunk now >>  http://get.splunk.com/
>_______________________________________________
>Ipw3945-devel mailing list
>Ipw3945-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
