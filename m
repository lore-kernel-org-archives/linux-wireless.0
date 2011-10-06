Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34636 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890Ab1JFSpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 14:45:47 -0400
Received: by qyk7 with SMTP id 7so2947381qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 11:45:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
 <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 6 Oct 2011 11:41:20 -0700
Message-ID: <CAB=NE6W5X-FJXCnzRyFPfqUZRWa6BCr=tg_pLngFR0ATg5Cwow@mail.gmail.com> (sfid-20111006_204550_619278_3E4D385A)
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 11:36 AM, Luis R. Rodriguez
<rodrigue@qca.qualcomm.com> wrote:
> On Thu, Oct 6, 2011 at 9:49 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:

>> Is this something about politics/laws I don't know about [I'm just
>> curious, because I don't really buy "testing" here, since Zefir
>> obviously has a working prototype
>
> No, we haven't passed certified testing with this code yet.

And to be clear, no there is no political issues here or concerns. The
law however is strict about DFS, extremely strict and I want to make
sure upstream code respect it well and we get the best DFS test
infrastructure out there to test this to ensure we get to the point to
always have DFS properly working upstream.

  Luis
