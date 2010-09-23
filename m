Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33038 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab0IWWX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 18:23:27 -0400
Received: from mail-wy0-f174.google.com (mail-wy0-f174.google.com [74.125.82.174])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id o8NMNOwg013657
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 17:23:25 -0500
Received: by wyb28 with SMTP id 28so1374888wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 15:23:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C9BC28E.7010105@candelatech.com>
References: <4C9BA6ED.8080304@candelatech.com> <AANLkTinY7y7Gf8K518293mdzXh5=42gQ64eUJjJFSaBw@mail.gmail.com>
 <4C9BC28E.7010105@candelatech.com>
From: Michael Griepentrog <griepent@cs.wisc.edu>
Date: Thu, 23 Sep 2010 17:22:58 -0500
Message-ID: <AANLkTinHY5LfzcQNvbVr6kY87Bjhy0TMYB8uU=k0ReZU@mail.gmail.com>
Subject: Re: Detect if phy is a/b/g/n?
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There should also be a "HT TX/RX MCS rate indexes supported:" for n rates.

Mike

On Thu, Sep 23, 2010 at 4:11 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 09/23/2010 01:35 PM, Luis R. Rodriguez wrote:
>>
>> On Thu, Sep 23, 2010 at 12:13 PM, Ben Greear<greearb@candelatech.com>
>>  wrote:
>>>
>>> Is there a way to determine what a/b/g/n modes a particular phy
>>> supports?  I tried 'iw phy', but I didn't see anything
>>> obvious.
>>
>> 'iw list' Rates?
>
> Both a/b/g (ath5k) and /n (ath9k) show top speed of 54Mbps
> on my systems.
>
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
