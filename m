Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40876 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753564AbcK2AIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 19:08:20 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Barry Day <briselec@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 0/7] rtl8xxxu: Pending patches
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
        <20161119014648.GA7140@testbox> <wrfjbmxcb55h.fsf@redhat.com>
        <20161119023830.GA7324@testbox> <wrfj37inauwp.fsf@redhat.com>
        <20161120024257.GA13169@testbox> <wrfj7f7w7oqk.fsf@redhat.com>
        <20161122122610.GA23278@testbox>
Date: Mon, 28 Nov 2016 19:08:18 -0500
In-Reply-To: <20161122122610.GA23278@testbox> (Barry Day's message of "Tue, 22
        Nov 2016 22:26:12 +1000")
Message-ID: <wrfj8ts3jggd.fsf@redhat.com> (sfid-20161129_010823_780626_AD477FBB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Barry Day <briselec@gmail.com> writes:
> On Mon, Nov 21, 2016 at 11:59:47AM -0500, Jes Sorensen wrote:
>> Barry Day <briselec@gmail.com> writes:
>> > Testing is simple. Connect to an AP in the usual
>> > manner..disconnect..reconnect.  The 8192eu will fail to reconnect and
>> > John Heenan reported the 8723bu also fails to reconnect. Even though
>> > he was directly stopping and restarting wpa_supplicant, it's the same
>> > thing to the driver - connect..disconnect..reconnect.
>> 
>> Thanks for the details - I'll have a look shortly.
>> 
>> > With using a usb_device pointer, each message starts with the usb bus
>> > address.  Plug it into a different port and that address could
>> > change. By using a pointer to the device associated with the wiphy
>> > each message will begin with the driver name. Just makes it easier for
>> > the average user to report what's in the log because he can just grep
>> > for "rtl8xxxu".
>> 
>> I see - that would be problematic for me as I quite often have 3-4 of
>> these things plugged in at the same time. Not knowing which port spits
>> out the message would make it a lot harder to track. In fact my primary
>> devel box for this (Lenovo Yoga 13) has an rtl8723au soldered on the
>> motherboard, so the moment I plug in any other dongle I'll have two.
>> 
>> The alternative would be to add a prefer to the individual messages.
>> 
>> Cheers,
>> Jes
>
> I should have mentioned it also places the usb address after the driver name.

If you're willing to cook up a patch, I'll have a look at it - I want to
see how it behaves though before deciding whether to approve it.

Cheers,
Jes
