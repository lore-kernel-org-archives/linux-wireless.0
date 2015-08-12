Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42007 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbbHLV2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 17:28:36 -0400
Message-ID: <1439414913.15847.1.camel@sipsolutions.net> (sfid-20150812_232842_089233_1CAB0395)
Subject: Re: iw coalesce show - disabled at init?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Aug 2015 23:28:33 +0200
In-Reply-To: <CAF7g2RGORavCuvoYzese0usNatsie5tjyN_7J_JgFDK9zurzLQ@mail.gmail.com> (sfid-20150812_231433_507702_04A67E98)
References: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com>
	 <1439413727.15847.0.camel@sipsolutions.net>
	 <CAF7g2RGORavCuvoYzese0usNatsie5tjyN_7J_JgFDK9zurzLQ@mail.gmail.com>
	 (sfid-20150812_231433_507702_04A67E98)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-12 at 14:13 -0700, Kobi Cohen-Arazi wrote:
> 
> So what you're saying is that at startup, drivers should have 
> coalesce _disabled_ (i.e. no rules for coalesce) ?
> 

I think so, yes. It's a service that should be actively enabled, with
user-configured rules. Mechanism vs. policy, and all that ...

johannes
