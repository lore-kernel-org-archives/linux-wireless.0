Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:57200 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab2FSQMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 12:12:52 -0400
Message-ID: <4FE0A502.6010707@opentechinstitute.org> (sfid-20120619_181255_502084_B4F5EE13)
Date: Tue, 19 Jun 2012 12:12:50 -0400
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/2 v3] mac80211/cfg80211: add support for userspace to
 handle auth frames on adhoc ifaces
References: <4FDFC5B2.1010807@opentechinstitute.org> <8762an6azv.fsf@purkki.adurom.net>
In-Reply-To: <8762an6azv.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/19/2012 03:01 AM, Kalle Valo wrote:
> Will Hawkins <hawkinsw@opentechinstitute.org> writes:
> 
>> Add cfg80211_mgmt_reg_match to cfg80211 to check for userspace
>> application registrations for management frames rx'd from a specific
>> interface. This function will be used by IBSS code to determine whether
>> or not to send out "open" authentication frames.
>>
>> Update documentation for cfg80211_rx_mgmt to note that "query" frames
>> are sent to matching userspace applications.
>>
>>
>> Signed-off-by: Will Hawkins <hawkinsw@opentechinstitute.org>
> 
> What's the user visible benefit from this? Does it add new features or
> something? You could document that in the commit log.
> 

Thank you for your feedback Kalle. I have to make some changes to this
patch set so I will definitely include a better description in my next
attempt.

Will
