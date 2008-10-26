Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:3948 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYJZBUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 21:20:07 -0400
Received: by rn-out-0910.google.com with SMTP id k40so863237rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2008 18:20:05 -0700 (PDT)
Message-ID: <445f43ac0810251820p71e6e330tba6ba9475ca8aa48@mail.gmail.com> (sfid-20081026_022028_483495_EFC3953E)
Date: Sat, 25 Oct 2008 18:20:05 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Cc: "Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200810251228.17562.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <200810251228.17562.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ivo,

On Sat, Oct 25, 2008 at 3:28 AM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> For rt2x00 this would turn into:
>        FIF_ALLMULTI | FIF_OTHER_BSS | FIF_PROMISC_IN_BSS

With the above configuration, will the rt2x00 device acknowledge 1)
unicast frames addressed to itself? 2) unicast frames addressed to
others? 3) none of the above?

Thanks,

Javier
