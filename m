Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3623 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1HQKjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 06:39:17 -0400
Message-ID: <4E4B9A45.5090507@broadcom.com> (sfid-20110817_123920_855701_EB9C06DC)
Date: Wed, 17 Aug 2011 12:39:01 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Williams" <dcbw@redhat.com>
cc: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
In-Reply-To: <1313509211.2065.36.camel@dcbw.foobar.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> 'Aug 14 13:39:02 stt300 NetworkManager[1181]:
>> supplicant_interface_acquire: assertion `mgr_state ==
>> NM_SUPPLICANT_MANAGER_STATE_IDLE' failed'
>>
>> I also see many 'wpa_supplicant[1204]: Failed to initiate AP scan' messages.
>>
>> There are no 'Failed to initiate AP scan' messages before the 'assertion
>> failed' message. I do not know if the 2nd message is a byproduct of the
>> 1st result. Regardless, a failed assertion is serious. I cc'ed the
>> network manager mailing list.

> Yeah, the scanning issues are almost certainly what's causing stuff to
> fail; which obviously seems like a driver issue at this point.

Well, the 1st sign that something goes wrong is the assert message in 
NetworkManager. After that, the scans are the next things that go wrong. 
So I don't understand why you think that this is a driver problem, I 
would rather say this is a Network manager problem. Could you explain ?

Thanks, Roland.

