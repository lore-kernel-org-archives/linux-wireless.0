Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:64391 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965538AbYCSWEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 18:04:48 -0400
Received: by wr-out-0506.google.com with SMTP id c48so586354wra.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 15:04:46 -0700 (PDT)
Message-ID: <1ba2fa240803191504i26732013ye34b6df817a06f0f@mail.gmail.com> (sfid-20080319_220630_208598_EF24B8BF)
Date: Thu, 20 Mar 2008 00:04:45 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Jouni Malinen" <j@w1.fi>,
	"Emmanuel Grumbach" <egrumbach@gmail.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205957728.16475.72.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu>
	 <1205831880.16475.43.camel@johannes.berg>
	 <20080318102344.GG5308@jm.kir.nu>
	 <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com>
	 <20080319173922.GB5308@jm.kir.nu>
	 <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
	 <20080319201004.GC5308@jm.kir.nu>
	 <1205957728.16475.72.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 10:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > The IEEE 802.11 name for this would be "default key". IEEE 802.1X (or
>  > well, RFC 3580 is the authoritative specification for this) calls it
>  > "broadcast (default key)". Please note that this is not really a key
>  > that is always used both for unicast and broadcast. If there is a
>  > key-mapping key (unicast/individual) for the matching
>  > transmitter/receiver addresses, that key will be used instead. The "old
>  > WEP key" way of using only statically configured default keys just does
>  > not set the key-mapping key and because of that, the default key ends up
>  > being used for all frames (or well, one of the possible four default
>  > keys).
>
>  That agrees with what I did in mac80211, but not with Intel's hardware.

You wish, you didn't have clue yourself :)

>  johannes
>
