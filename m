Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:2298 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYBTSwq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:52:46 -0500
Message-ID: <47BC76FC.7070109@errno.com> (sfid-20080220_185250_790411_4584F62A)
Date: Wed, 20 Feb 2008 10:52:44 -0800
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Renzmann <mrenzmann@madwifi.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	bruno randolf <br1@einfach.org>
Subject: Re: implementing APSD?
References: <1203521087.17534.74.camel@johannes.berg> <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com>
In-Reply-To: <1ba2fa240802201043v1bd4fbddsc55c2230eb2a1480@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> On Feb 20, 2008 5:24 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>   
>> Hi,
>>
>> I've long thought about implementing APSD but it seems to require
>> setting the "more data" bit in an ACK frame and various other things.
>> Ron, I think you're the QoS expert, is that really how APSD works? If
>> so, does iwl firmware implement that?
>>     
>
> We have uAPSD implementation, mainly AP part, yet again it for  older
> mac. It will take a bit time to merge it in
> It's a mandatory feature for HT AP.
>   

Really?  Can you point where that's called out in the spec?

>   
>> Also, does Atheros hardware implement that, and how? It doesn't look
>> like Broadcom firmware implements it, and I don't really understand how
>> one could implement it without many hardware queues, since it seems
>> timing critical to send out the frames to the station that is using
>> APSD.
>>
>>     
> Don't believe it's possible to that without HW support.
>   

Sorry, this is incorrect; you can do UAPSD w/o any special h/w support.

    Sam

