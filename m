Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3242 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1HSOch (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Aug 2011 10:32:37 -0400
Message-ID: <4E4E73F4.4040105@broadcom.com> (sfid-20110819_163241_142772_6213AFD6)
Date: Fri, 19 Aug 2011 16:32:20 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: "Dan Williams" <dcbw@redhat.com>,
	=?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
In-Reply-To: <4E4CC85A.7010504@broadcom.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hello Dan,
>
> can you reply ?

So much for responsiveness.

Camaleon, would you be able to provide additional logs as requested in 
one of my previous mails ?

Thanks, Roland.

>
> Thanks, Roland.
>
> On 08/17/2011 12:39 PM, Roland Vossen wrote:
>>>> 'Aug 14 13:39:02 stt300 NetworkManager[1181]:
>>>> supplicant_interface_acquire: assertion `mgr_state ==
>>>> NM_SUPPLICANT_MANAGER_STATE_IDLE' failed'
>>>>
>>>> I also see many 'wpa_supplicant[1204]: Failed to initiate AP scan' messages.
>>>>
>>>> There are no 'Failed to initiate AP scan' messages before the 'assertion
>>>> failed' message. I do not know if the 2nd message is a byproduct of the
>>>> 1st result. Regardless, a failed assertion is serious. I cc'ed the
>>>> network manager mailing list.
>>
>>> Yeah, the scanning issues are almost certainly what's causing stuff to
>>> fail; which obviously seems like a driver issue at this point.
>>
>> Well, the 1st sign that something goes wrong is the assert message in
>> NetworkManager. After that, the scans are the next things that go wrong.
>> So I don't understand why you think that this is a driver problem, I
>> would rather say this is a Network manager problem. Could you explain ?
>>
>> Thanks, Roland.
>


