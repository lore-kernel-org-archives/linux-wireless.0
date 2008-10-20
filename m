Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:4218 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYJTTqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 15:46:01 -0400
Received: by yx-out-2324.google.com with SMTP id 8so335760yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 12:45:59 -0700 (PDT)
Message-ID: <43e72e890810201245t3ac18fd6taf229af88350958f@mail.gmail.com> (sfid-20081020_214608_548382_832135D1)
Date: Mon, 20 Oct 2008 12:45:59 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Daniel Gimpelevich" <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Marvell TopDog Driver Work
Cc: linux-wireless@vger.kernel.org,
	"Lennert Buytenhek" <buytenh@wantstofly.org>
In-Reply-To: <1224525810.6873.8.camel@the-omnibook>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48A5DBAB.9080405@erley.org> <20080815195825.GD5935@tesla>
	 <1218830917.14841.20.camel@localhost.localdomain>
	 <gdidhg$hdq$3@ger.gmane.org>
	 <1224524168.29822.46.camel@dhcp-100-3-195.bos.redhat.com>
	 <1224525810.6873.8.camel@the-omnibook>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 11:03 AM, Daniel Gimpelevich
<daniel@gimpelevich.san-francisco.ca.us> wrote:

> The "Duh..." was a response to the "Not that I have heard of. Don't
> know." statement, which was pretty ironic.

Well your question was "Has anyone stepped up to help in the port of
this to mac80211" and I thought you already knew I had that tree.

> The rest was intended to be
> context. Any net80211-based code for TopDog would still be a useful
> reference for the 11n-specific bits that would need to be added to mrv8k
> after it works correctly with CardBus 11g cards. What is the canonical
> URL for the experimental source repository for those, BTW?

As documented in my git tree, I took the code from John's tree, which
I think is the canonical reference. John's tree includes the entire
Linux kernel tree though, that's why I tried to start out separately
with a driver that will just compile using the kernel headers.

> More thanks go out to Lennert for his work on the Marvell CPU cores,
> too.

ACK -- will mrv8k not support top dog?

  Luis
