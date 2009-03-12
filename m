Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:33765 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504AbZCLVdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 17:33:47 -0400
Received: by qw-out-2122.google.com with SMTP id 5so1242620qwi.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 14:33:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com>
References: <1236728344.26432.26.camel@maxim-laptop>
	 <d94c510d0903110115s620c7851g391fcf00e644a113@mail.gmail.com>
	 <b6c5339f0903120714rda8ec3ev2c2fbfaaf0b21351@mail.gmail.com>
	 <1236893111.30325.10.camel@maxim-laptop>
	 <b6c5339f0903121432h26d71d6nd901f12d0c10e7bc@mail.gmail.com>
Date: Thu, 12 Mar 2009 17:33:44 -0400
Message-ID: <b6c5339f0903121433r7bbf2dd8l484d15446241dccd@mail.gmail.com> (sfid-20090312_223401_484700_7CA41ABA)
Subject: Re: [ath5k-devel] Thanks for TX power patch
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nick Kossifidis <mick@madwifi-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 12, 2009 at 5:32 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Thu, Mar 12, 2009 at 5:25 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> Just to be clear, I got oopses, and hangs after resume from disk by just
>> using compat-wireless-2009-03-10 _without_ Nick's patches.
>
> Interesting, I thought you said that, but I tried the same stuff on
> plain wireless testing and didn't have any problems.

Oh, and you said compat-wireless -- can you try wireless-testing just
to make sure it's not some structure definition build conflict with
compat-wireless?

-- 
Bob Copeland %% www.bobcopeland.com
