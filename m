Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:35912 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894AbXKORhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 12:37:00 -0500
Message-ID: <473C83B9.3010207@telenet.be> (sfid-20071115_173717_413621_2EC8AB74)
Date: Thu, 15 Nov 2007 18:36:57 +0100
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Ismail_?= =?ISO-8859-1?Q?D=F6nmez?=
	<ismail@pardus.org.tr>, Dan Williams <dcbw@redhat.com>,
	Stephen.Clark@seclark.us, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
References: <20071017135452.GJ5043@kernel.dk> <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com> <473514F3.50500@telenet.be> <200711150253.48628.ismail@pardus.org.tr> <20071115093921.GH638@kernel.dk> <20071115151046.GA12902@tuxdriver.com> <20071115151425.GF5035@kernel.dk>
In-Reply-To: <20071115151425.GF5035@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I believe that a main problem is that people have trouble reproducing i=
t.
and despite my -somewhat- implicit question there is not more informati=
on
in this thread now. Other than some symptoms. It would probably help if=
 you
posted system/software specifications and debug info to a (new) bug ove=
r at
bughost.org. (modprobe iwl3945 debug=3D0x43fff) to allow for it to be t=
racked better?

Because now imho we are just poking at it with a medium length stick.

With the information here, I honestly have no idea where to look, other=
s might
have the same problem.

ian

Jens Axboe wrote:
> On Thu, Nov 15 2007, John W. Linville wrote:
>> On Thu, Nov 15, 2007 at 10:39:22AM +0100, Jens Axboe wrote:
>>> On Thu, Nov 15 2007, Ismail D=F6nmez wrote:
>>>> Saturday 10 November 2007 Tarihinde 04:18:27 yazm????t??:
>>>>> I wonder if anybody knows something more about this issue by now,
>>>>> as it appears to occur to a few people.
>>>>>
>>>>> I reread the thread (rather quickly) but I do not see many specif=
ications
>>>>> of driver/mac80211/kernel. The few cases that do contain specs al=
l appear
>>>>> to be using fedora (don't want to jump to conclusions). But just =
wondering
>>>>> if anybody experienced this on any other kernel?
>>>> Btw this is still not fixed in latest git (post rc2).
>>> I'll second that, using todays snap still requires me to do an iwli=
st
>>> scan before I can use the network.
>>>
>>> Is anyone working on this at all? This was reported a month ago, ye=
t no
>>> progress or real developer interest in fixing this is apparent.
>> I don't see any pending patches that seem relevant.  FWIW I'll proba=
bly
>> round-up what I do have and make them available today (and probably
>> in a Fedora kernel too).
>>
>> Does the disable_hw_scan=3D1 still work for you?  Perhaps we should
>> consider making that the default...
>=20
> disable_hw_scan=3D1 never worked for me - I tried it, and it made no
> difference. I _have_ to do an iwlist wlan0 scan before it links with =
my
> access point, otherwise it doesn't work.
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
