Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:33724 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753029Ab0H1RTM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 13:19:12 -0400
Message-ID: <4C79450C.80507@redfish-solutions.com>
Date: Sat, 28 Aug 2010 11:19:08 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
References: <4C746F74.70401@redfish-solutions.com> <20100828171239.GA23885@jm.kir.nu>
In-Reply-To: <20100828171239.GA23885@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/28/10 11:12 AM, Jouni Malinen wrote:
> On Tue, Aug 24, 2010 at 06:18:44PM -0700, Philip Prindeville wrote:
>>   I've got a stock Fedora Core 13 install (updated today) with the hostapd-0.6.10 rpm and hostapd-0.7.2 compiled from sources.  The NIC is a Ubiquiti SR71e (AR9280).
>> (2) Some highly unlikely values from the hostapd debugging messages when parsing out WEP authentication messages (line 507):
>> authentication: STA=f8:1e:df:1e:c2:23 auth_alg=35510 auth_transaction=79 status_code=21688 wep=1
>> Unsupported authentication algorithm (35510)
> I was unable to reproduce this with the current development tree
> snapshots. Shared key authentication worked with AR9280 and the current
> wireless-testing.git and hostap.git in my tests. If you are still seeing
> this, you could also try to disable hw crypto to remove one possible
> issue area by using nohwcrypt=1 module parameter when loading ath9k.
>

Already tried that, and it didn't help.

-Philip

