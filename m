Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:46866 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751548AbdIOT5D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 15:57:03 -0400
Received: by mail-pf0-f174.google.com with SMTP id e199so1965056pfh.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Sep 2017 12:57:03 -0700 (PDT)
Subject: Re: iwlwifi firmware load broken in current -git
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Luca Coelho <luca@coelho.fi>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <04c9b578-693c-1dc6-9f0f-904580231b21@kernel.dk>
 <1505232673.5400.243.camel@intel.com> <1505234187.5400.249.camel@coelho.fi>
 <4bcbcbc1-7c79-09f0-5071-bc2f53bf6574@kernel.dk>
 <1505246657.1974.11.camel@sipsolutions.net>
 <feabbc25-eb85-ffa2-0fd6-254c07e3574b@kernel.dk>
 <CAErSpo777jq9FVRtmoHXVbzE-ZOc7mnT+eRJ_PhP_Dd=MbKv4g@mail.gmail.com>
 <e7af2f85-0ab3-e524-a544-c2ccdf4f8bd6@kernel.dk>
 <CABe79T7WObM+LOGdPFfYC7hf0dKrhm5NwMgQ3DpcWst3eP6kNg@mail.gmail.com>
 <8de8d1e2-1673-e1ff-d0ac-6d3bb03e9e99@kernel.dk>
 <93bfbc9b-8829-66fa-f4d6-6d47124e460c@kernel.dk>
 <CABe79T79WhBh66iQB-5LLCQO0d37evg5tsKUGkj7+z8vNGTHcA@mail.gmail.com>
 <a5fd0c11-916f-1404-c979-2fd566ed72ec@kernel.dk>
 <ee04c95d-167b-0782-1860-253a2271d66c@kernel.dk>
 <CA+55aFzjz2c=q4Uatso1Lp6HAUOAyGdbZLWorFW56MiapoF5Sg@mail.gmail.com>
 <1505504598.5400.296.camel@coelho.fi>
 <CA+55aFxUUTJo=EPHqHB8qEm_72mrM6P0pzbLqL0PQ8s2SM+ZiQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8d24ffdd-7064-677b-4bac-fbb5dda62f83@kernel.dk> (sfid-20170915_215707_371119_A6C68DB6)
Date: Fri, 15 Sep 2017 13:57:00 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFxUUTJo=EPHqHB8qEm_72mrM6P0pzbLqL0PQ8s2SM+ZiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2017 01:51 PM, Linus Torvalds wrote:
> On Fri, Sep 15, 2017 at 12:43 PM, Luca Coelho <luca@coelho.fi> wrote:
>> On Fri, 2017-09-15 at 12:38 -0700, Linus Torvalds wrote:
>>>
>>> From some of the context it looks like commit 40f11adc7cd9 ("PCI:
>>> Avoid race while enabling upstream bridges"), is that correct?
>>
>> Yes, that's the one.  And Bjorn already sent a revert:
>>
>> https://lkml.org/lkml/2017/9/15/46
> 
> Well, he may have sent a revert to lkml, but not to me. I'm assuming
> it's in his tree and I'll get a pull request. Hopefully soon, so that
> it makes rc.

That was my hope, and why I emailed again today on the topic.

> Jens, you were actually cc'd on that revert according to the email
> headers, so check your spam-box.

Yeah, Luca says so too. Which is making me a little worried on behalf
of my email, since it's not sitting in spam.

-- 
Jens Axboe
