Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-156-71.gdrpmi.dsl-w.verizon.net ([71.115.156.71]:42864
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZA2AjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 19:39:19 -0500
Message-ID: <4980FAB3.9050706@erley.org> (sfid-20090129_013923_003114_D1E1DFFB)
Date: Wed, 28 Jan 2009 19:39:15 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH resend] crda: rename nl_handle to nl_sock for libnl-2.0
References: <4980EDC8.4050204@erley.org>	 (sfid-20090129_004437_360979_B9D4728F) <1233187526.16048.95.camel@johannes.local>	 <4980F67C.70207@erley.org> <1233189164.16048.106.camel@johannes.local>
In-Reply-To: <1233189164.16048.106.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-01-28 at 19:21 -0500, pat-lkml wrote:
>> Johannes Berg wrote:
>>> On Wed, 2009-01-28 at 18:44 -0500, pat-lkml wrote:
>>>> Upstream has renamed nl_handle to nl_sock.  Update crda to the new names
>>>> and add #define for libnl-1.1.
>>> But libnl-2.0 comes with a define too:
>>> #define nl_handle nl_sock
>>>
>>> you just need to include the right headers, no?
>>>
>>> johannes
>> dunno.... but I can't find it:
>>
>> libnl $ egrep "#define nl_handle" * -r
>> libnl $ git pull
>> Already up-to-date.
> 
> Ah. Grr. Just recently removed.
> 
> johannes

Which leads back around to my question, should I continue pushing
patches like this your way (after making sure the right patch is on the
right e-mail with the right description), or do we want to wait and I'll
just maintain the patches outside of git, and push them once libnl-2.0
hits?  On one hand, it makes testing both versions easier, on the other,
it makes a lot of little 'fix' commits like this.  I have no issues
maintaining these sorts of patches, but I don't want to do it if you
don't want them.

Pat
