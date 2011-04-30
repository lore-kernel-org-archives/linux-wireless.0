Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.si.unav.es ([159.237.12.161]:33174 "EHLO smtp1.si.unav.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619Ab1D3Ns0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 09:48:26 -0400
Message-ID: <20110430154823.19371xuwpgd2ewqs@webmail.unav.es> (sfid-20110430_154828_500943_8CA82174)
Date: Sat, 30 Apr 2011 15:48:23 +0200
From: Wenceslao =?iso-8859-1?b?R29ueuFsZXotVmnxYXM=?=
	<wens@fisica.unav.es>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"622842@bugs.debian.org" <622842@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 not setting correct country code?
References: <20110415070730.4178.6175.reportbug@calpurnia>
 <20110415081334.GD1387@vostochny.stro.at>
 <20110415161039.15535n2vg4igcykg@webmail.unav.es>
 <20110429164822.62112d9at4vs5xa8@webmail.unav.es>
 <1304088874.3105.57.camel@localhost>
 <20110429173944.10906p14p6bdid4w@webmail.unav.es>
 <1304139874.2833.29.camel@localhost> <4DBBC4DA.8000101@broadcom.com>
 <20110430103817.14736hcizu57ujrw@webmail.unav.es>
 <4DBBF2CF.8050608@broadcom.com> <1304170750.2833.31.camel@localhost>
In-Reply-To: <1304170750.2833.31.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Ben,

If you want, I could try with this modified of wireless-regdb ... Just  
tell me how to obtain it .

Best and thanks again,

Wenceslao


Ben Hutchings <ben@decadent.org.uk> ha escrito:

> On Sat, 2011-04-30 at 13:30 +0200, Arend van Spriel wrote:
>> On 04/30/2011 10:38 AM, Wenceslao González-Viñas wrote:
>> > After
>> > iw reg set EU
>> > I do not get any answer in dmesg log.
>>
>> I assume you did this as root or used sudo. You may have to check
>> whether you have the proper udev rules in place. See
>> http://wireless.kernel.org/en/developers/Regulatory/CRDA#Letting_the_kernel_call_CRDA
>
> They are.
>
>> > and if I do (after)  : iw reg get , I get:
>> >
>> > country 98:
>> > 	(2402 - 2472 @ 40), (N/A, 20)
>> > 	(5170 - 5250 @ 40), (N/A, 17)
>> > 	(5250 - 5330 @ 40), (N/A, 20), DFS
>> > 	(5490 - 5600 @ 40), (N/A, 20), DFS
>> > 	(5650 - 5710 @ 40), (N/A, 20), DFS
>> >
>> > So, something is not working properly.
>>
>> I get country US (after iw reg set EU). I tried 'iw reg set ES' after
>> that and another message showed up in the log:
>> [ 1613.052044] cfg80211: Calling CRDA for country: EU
>> [ 1845.365115] cfg80211: Pending regulatory request, waiting for it to
>> be processed...
>>
>> It seems cfg80211 expects CRDA to respond to the country setting for EU.
>> I am not familiar what modules are involved in this usage scenario.
>
> I added 'EU' to wireless-regdb in Debian for backward-compatibility.
>
> Ben.
>
> --
> Ben Hutchings
> Once a job is fouled up, anything done to improve it makes it worse.
>




----------------------------------------------------------------
Este mensaje ha sido enviado desde https://webmail.unav.es
