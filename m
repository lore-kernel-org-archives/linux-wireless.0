Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:63194 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbYHANnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 09:43:06 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1440274wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 01 Aug 2008 06:43:05 -0700 (PDT)
Message-ID: <b6c5339f0808010643i58dbb2a7jf459359451061ae4@mail.gmail.com> (sfid-20080801_154310_970397_A167421F)
Date: Fri, 1 Aug 2008 09:43:05 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] ath5k : ath5k_config_interface deadlock fix
Cc: "Pekka Enberg" <penberg@cs.helsinki.fi>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Dave Young" <hidave.darkstar@gmail.com>,
	johannes@sipsolutions.net, tomasw@gmail.com,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net, linville@tuxdriver.com,
	stable@kernel.org
In-Reply-To: <20080801011415.ff4821a3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080801074014.GA3341@darkstar> <4892C2CA.7010003@gmail.com>
	 <4892C359.9000304@cs.helsinki.fi>
	 <20080801011415.ff4821a3.akpm@linux-foundation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 1, 2008 at 4:14 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 01 Aug 2008 11:03:37 +0300 Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>
>> Jiri Slaby wrote:
>> > Dave Young napsal(a):
>> >> In the drivers/net/wireless/ath5k/base.c, there's recursive locking of
>> >> sc->lock
>> >
>> > Should be fixed already:
>> > http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commitdiff_plain;h=bc05116ab33d30342e2b4b1bcc6d6e1184e9df97
>>
>> I guess that didn't make it to -stable?
>
> (cc stable!)

Not to worry, the commit that introduced it was
9d139c810a2aa17365cc548d0cd2a189d8433c65, which as far as I can tell
came in after 2.6.26.

-- 
Bob Copeland %% www.bobcopeland.com
