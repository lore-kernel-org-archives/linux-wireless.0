Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51550 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751903AbdLUK5N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Dec 2017 05:57:13 -0500
Message-ID: <1513853827.4827.504.camel@coelho.fi> (sfid-20171221_115741_073255_EB398E96)
From: Luca Coelho <luca@coelho.fi>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        it+linux-wireless@molgen.mpg.de
Date: Thu, 21 Dec 2017 12:57:07 +0200
In-Reply-To: <4e18369a-4f39-3988-2072-5c7b9490b614@molgen.mpg.de>
References: <75bc638e-99a8-2f3f-6260-491f8a018af6@molgen.mpg.de>
         <1513175552.4827.365.camel@intel.com> <1513621815.4827.430.camel@coelho.fi>
         <a08aa1b3-9d75-2f38-a0f0-aefe181137da@molgen.mpg.de>
         <87r2ro9xhq.fsf@purkki.adurom.net>
         <4e18369a-4f39-3988-2072-5c7b9490b614@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: UBSAN: Undefined behaviour in
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c:838:5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-21 at 11:49 +0100, Paul Menzel wrote:
> Dear Kalle,
> 
> 
> On 12/21/17 11:38, Kalle Valo wrote:
> > Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de> writes:
> > 
> > > > http://pastebin.coelho.fi/7b624f474846da52.txt
> > > 
> > > Thank you. The warning is gone now. Thank you. For the next time,
> > > it’d
> > > be great to provide the output of `git format-patch -1`, which
> > > can be
> > > applied with `git am`. The output of `git show` is with my
> > > knowledge
> > > hard to apply.
> > 
> > 'patch -p1 < foo.patch' should work. Of course it omits the commit
> > log
> > but is usually enough for testing purposes.
> 
> That’s what I did in the end. And then I have to do `git commit -a`
> to 
> get the tree in a clean state.
> 
> So `git format-patch -1` and uploading of that, for example with
> some 
> CLI tool, for the win. ;-)

The choice here is: more work for me vs. more work for you. :) But I
guess I can easily do "git format-patch -1 --stdout" and pipe it to my
pastebin script...

--
Luca.
