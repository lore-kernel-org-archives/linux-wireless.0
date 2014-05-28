Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:64870 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbaE1TeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 15:34:03 -0400
Received: by mail-qg0-f53.google.com with SMTP id f51so19198440qge.12
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 12:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401283656.8146.17.camel@jlt4.sipsolutions.net>
References: <2083629.VLZzpqGjAs@desktop.local> <1401283040.8146.15.camel@jlt4.sipsolutions.net>
 <CAGnRvuq1By_dZZnv3Vcm+JRxpkyZwv8NfEv4cM-1QChwX-+eqA@mail.gmail.com> <1401283656.8146.17.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 28 May 2014 21:33:40 +0200
Message-ID: <CAGnRvuqcMm6A6SPuuPHaahxBAvSM+oHUs3NJRN4N8jsSijVQLQ@mail.gmail.com> (sfid-20140528_213407_677782_E7B1DFF5)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@noack.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 3:27 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> The current patch ONLY unifies the mpp_path_add() and mesh_path_add()
>> function. But I could factor out the addition of the atomic counter
>> for mpp_paths into a patch of its own.
>
> Please.

*sigh* new version of the patch will be coming later...

the existing atomic counter thing in mesh_pathtbl.c is slightly broken
and I have to look how to fix it before I can think about the
unification thing again.

Maybe I will try to work on the nl80211 addition for mpp_dumps in
parallel, but all the "tracing event" code looks still quite obscure
to me.

Henning Rogge
