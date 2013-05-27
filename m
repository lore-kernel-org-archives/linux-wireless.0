Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2089 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab3E0TUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:20:33 -0400
Message-ID: <51A3B1F5.4070507@broadcom.com> (sfid-20130527_212038_515498_B90F80AE)
Date: Mon, 27 May 2013 21:20:21 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Jouni Malinen" <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jithu Jance" <jithu@broadcom.com>,
	"Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: P2P Device support: how to deal with p2p_no_group_iface
 option
References: <51A09F43.5030004@broadcom.com>
 <1369645418.8229.17.camel@jlt4.sipsolutions.net>
 <51A36603.7020403@broadcom.com> <20130527181112.GA20210@w1.fi>
 <1369682153.14740.27.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369682153.14740.27.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2013 09:15 PM, Johannes Berg wrote:
> On Mon, 2013-05-27 at 21:11 +0300, Jouni Malinen wrote:
>> On Mon, May 27, 2013 at 03:56:19PM +0200, Arend van Spriel wrote:
>>> In this mac80211_hwsim is a special case. We could make P2P_DEVICE
>>> support in mac80211_hwsim optional using module parameter to allow
>>> testing both cases.
>>
>> Yes, that would be helpful. I don't understand why my test setup moves
>> to using P2P Device by default when mac80211_hwsim is perfectly capable
>> of operating without that.. [...]
>>
>> In general, I don't think it is a good idea to change existing behavior
>> with a kernel or wpa_supplicant upgrade. It is obviously fine if this is
>> needed for the functionality to work in the first place, but that is not
>> the case with mac80211_hwsim.
>
> It's kinda a side effect of having "I support P2P-Device" also mean "I
> want P2P-Device to be used", but for everything other than hwsim that
> seems like the only reasonable choice, so ... I wouldn't mind changing
> the default in hwsim though to not support/desire P2P-Device w/o a
> configuration option or so.

Hi Johannes,

Marcel suggested a different approach that sounds pretty compelling from 
a test perspective. However, that does change mac80211_hwsim behaviour 
more significantly. No pain, no gain :-)

Regards,
Arend

