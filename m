Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([87.79.32.166]:4031 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbYHBT1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 15:27:24 -0400
Message-ID: <4894B518.1000207@wpkg.org> (sfid-20080802_212726_665120_66BC7C97)
Date: Sat, 02 Aug 2008 21:27:20 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
CC: linux-wireless@vger.kernel.org
Subject: Re: wireless USB adapters recommendations?
References: <4894AC77.5060801@wpkg.org> <g72be3$gpf$1@ger.gmane.org>
In-Reply-To: <g72be3$gpf$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Gimpelevich schrieb:
> On Sat, 02 Aug 2008 20:50:31 +0200, Tomasz Chmielewski wrote:
> 
>> I'm looking for a USB wireless adapter which is well supported under
>> Linux.
>>
>> Requirements:
>>
>> - WPA2
>> - should support ad-hoc and access point modes - should work under
>> mipsel (I had once a prism54 mini-PCI card which didn't work under
>> mipsel)
>>
>> It would be also nice to to get the hardware from a producer which
>> cooperates with Linux community.
>>
>> Do you guys have any recommendations?
> 
> Your requirements are mutually exclusive at the moment.

Obviously, it doesn't have to support both ad-hoc and access point modes 
at the same time if that's what you mean ;)


> Here is what the 
> FSF says on the matter:
> http://www.fsf.org/resources/hw/net/wireless/cards.html

According to that page, there are only two supported USB adapters... at 
least when you search for the "USB" string.


> Access-point mode is now dependent upon nl80211, which isn't finished yet.

So, there is no wireless USB adapter working with Linux supports access 
point mode now, because some parts of nl80211 are not ready yet?

I see nl80211 is in vanilla kernel now; what features still lack to 
provide access point functionality (to wireless USB adapters)? Any time 
frames (2.6.28? later?)?


-- 
Tomasz Chmielewski
http://wpkg.org
