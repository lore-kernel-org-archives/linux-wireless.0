Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:43586 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbYJGT2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 15:28:34 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2430059fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 07 Oct 2008 12:28:32 -0700 (PDT)
Message-ID: <1ba2fa240810071228m52a60861r5558529426b9b487@mail.gmail.com> (sfid-20081007_212838_971873_8732DC78)
Date: Tue, 7 Oct 2008 21:28:32 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: get rid of IWL_{GET,SET}_BITS crap
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1223398724.7328.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223311803.15196.36.camel@johannes.berg>
	 <1ba2fa240810061135t24f2dfbv2a5eb0cd5d9e8cd7@mail.gmail.com>
	 <200810070821.56462.hs4233@mail.mn-solutions.de>
	 <20081007071529.GA5010@infradead.org>
	 <20081007131615.GR3448@tuxdriver.com>
	 <1ba2fa240810070703j471faa30mce3678febf3c20e8@mail.gmail.com>
	 <1223398724.7328.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 7, 2008 at 6:58 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-07 at 16:03 +0200, Tomas Winkler wrote:
>
>> > Now, can we discuss the patch rather than Johannes' intemperate
>> > word choice?
>>
>> With Johannes permissions I will split the patch into chunks first so
>> I can take smaller steps second
>> it will better fit into patches I have in pipe.
>
> Fine with me, can you adopt the first one too that cleans up the DMA
> code?
Yes I handling that too.
 And please keep the 10 pairs -> 20 addresses, it's a lot easier to
> understand :)
I don't like on this solution two things one is that it 32 bit
variables sits on unaligned address and second
it doesn't mach HW description which defines this as  descriptor couple

Tomas
