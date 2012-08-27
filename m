Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54067 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696Ab2H0RSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 13:18:12 -0400
Received: by pbbrr13 with SMTP id rr13so7781659pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 10:18:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj984VD6VmnX5nP0bCV7-pb-YPQ55eX2Gusg4G4jwRV7O9ng@mail.gmail.com>
References: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com>
 <CAG6hwVMQckH9KYp=OZorb2Q__91VrC-V5MNqE+zXsCTN4B5=dg@mail.gmail.com> <CAEFj984VD6VmnX5nP0bCV7-pb-YPQ55eX2Gusg4G4jwRV7O9ng@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 27 Aug 2012 10:17:51 -0700
Message-ID: <CAG6hwVNZYM6hQe9BvhP2eyFCMWTk7-HbZBx9hqikwQNkdF_6cQ@mail.gmail.com> (sfid-20120827_191816_871984_BE4D4B09)
Subject: Re: [PATCH] cfg80211: allow software encryption of aes cmac in mesh
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2012 at 8:24 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Thomas
>
>> So what does this patch fix, exactly? mac80211 already advertises
>> support for AES CMAC if the hardware is MFP capable.
>
> I think that ath5k is not hardware MFP capable, but actually could do
> AES CMAC in software. But key installation using AES CMAC of authsae
> on the multicast management frame are failed due to the checking of
> cfg80211_supported_cipher_suit which is based on
> IEEE80211_HW_MFP_CAPABLE. So the only way is bypass this checking.
> What do you think?

But this is ugly. I liked your ath5k patch better and am not really
sure what Johannes' problem with it was?

Thomas
