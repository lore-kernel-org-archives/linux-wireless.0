Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52930 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbeIXRKD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 13:10:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        wireless <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, tehuang@realtek.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <20180921131235.GA10556@redhat.com>
        <CAP71bdW0P8xFeLfGgNeENJf_9+S+DTnK4S=tXZi1FPY7U-AL3A@mail.gmail.com>
Date: Mon, 24 Sep 2018 14:08:25 +0300
In-Reply-To: <CAP71bdW0P8xFeLfGgNeENJf_9+S+DTnK4S=tXZi1FPY7U-AL3A@mail.gmail.com>
        (Larry Finger's message of "Sat, 22 Sep 2018 16:59:32 -0500")
Message-ID: <87lg7r40gm.fsf@codeaurora.org> (sfid-20180924_130836_832059_D51DF3E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding greg)

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On Fri, Sep 21, 2018 at 8:12 AM Stanislaw Gruszka
> <sgruszka@redhat.com> wrote:
>
>     On Fri, Sep 21, 2018 at 02:03:55PM +0800, yhchuang@realtek.com
>     wrote:
>     
>     I didn't do detailed review, but my general impression is very
>     very
>     positive. New driver looks great!
>     
>     Just 2 generic remarks:
>     - please add MAINTAINERS file entry
>     - please post a patch or request to remove staging/rtlwifi driver
>     since this one is replace for it (8822BE PCI-ID is the same)
>
> Keep in mind that the new driver is going into wireless, and the old
> one is in staging. With separate maintainers, doing this in a single
> series of commits is very difficult to coordinate. One way would be to
> submit the deletion patch to GregKH (or whomever is maintaining
> staging) with a note that it should be held until rtwlan appears in
> mainline, and then submitted directly to mainline as well as staging.
> I'm sure there will be a solution, just that it cannot be handled as a
> normal patch set.

My guess is that Greg would be ok that we remove the staging driver via
wireless-drivers-next at the same time as we apply the new driver to
drivers/net/wireless. But let's coordinate that with Greg once this new
driver is ready for commit, we are not quite there yet.

-- 
Kalle Valo
