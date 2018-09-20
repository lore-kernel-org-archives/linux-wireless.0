Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51162 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeITVEI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 17:04:08 -0400
Message-ID: <cc1e018aafb6b045c17ad02b3f8c69bfd478fd93.camel@coelho.fi> (sfid-20180920_172014_176275_78E5EFD0)
From: Luca Coelho <luca@coelho.fi>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc: linuxwifi@intel.com
Date: Thu, 20 Sep 2018 18:20:05 +0300
In-Reply-To: <CAHmME9oCoZ+1O-QOdkQYp_tCw1zDa3--9RVenJON4Uud60oYhw@mail.gmail.com>
References: <CAHmME9oBQqT5B9cnY530czZ53hoqyMsXeAf7OURhrX=wZv1Qvw@mail.gmail.com>
         <CAHmME9oCoZ+1O-QOdkQYp_tCw1zDa3--9RVenJON4Uud60oYhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: disconnection regression in 4.17?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-09-14 at 12:36 +0200, Jason A. Donenfeld wrote:
> Hi again,

Hi Jason,


> I can confirm that this issue is still present in 4.18. I'm receiving
> very frequent disconnections:
> 
> [  304.707603] wlan0: deauthenticated from <> (Reason:
> 6=CLASS2_FRAME_FROM_NONAUTH_STA)
> 
> The last working kernel was in the 4.16 series. Any ideas?

Do you consistently *not* see this with 4.16? Any chance you could
bisect the problem?

Other information could also be helpful, please see:
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

And, if possible, please open a bug in bugzilla and set 
linuxwifi@intel.com as the assignee.

Thanks!

--
Cheers,
Luca.
