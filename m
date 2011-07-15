Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62500 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1GOSRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 14:17:40 -0400
Received: by wyg8 with SMTP id 8so980598wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 11:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMo8BfKk+c_Ywjd-mJ4N5zAUxr4t5sRQC4Gq-UrbSW2WwDUnPg@mail.gmail.com>
References: <1310600747-9583-1-git-send-email-thomas@cozybit.com>
	<CAMo8BfKk+c_Ywjd-mJ4N5zAUxr4t5sRQC4Gq-UrbSW2WwDUnPg@mail.gmail.com>
Date: Fri, 15 Jul 2011 11:17:39 -0700
Message-ID: <CAG6hwVNmqpS=b9kKW__uxKnPYB1HwvjZ4oeobadFtXsMhoc_0Q@mail.gmail.com> (sfid-20110715_201744_092166_19D3077C)
Subject: Re: [PATCH 0/5] mac80211: mesh beaconing
From: Thomas Pedersen <thomas@cozybit.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 3:50 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
>> Currently, mesh beacons have IEs either missing or in the wrong order. Update
>> the mesh beacon to the proper format specified in 802.11s draft 12.0. This
>
> Thomas, what is the exact draft version number?

D12.0 from 5/20/2011 is the latest version I currently have access to.

>
>> patch set will be part of a greater effort to update the mesh stack in mac80211
>> in anticipation of the ratification of the 802.11s standard.
>
> --
> Thanks.
> -- Max
>
