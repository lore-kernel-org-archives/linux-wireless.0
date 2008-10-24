Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.245]:33505 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYJXRF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 13:05:58 -0400
Received: by hs-out-0708.google.com with SMTP id 4so372198hsl.5
        for <linux-wireless@vger.kernel.org>; Fri, 24 Oct 2008 10:05:57 -0700 (PDT)
Message-ID: <445f43ac0810241005i1b7d23f5lfed64bab86df536d@mail.gmail.com> (sfid-20081024_190602_862644_CDEADE30)
Date: Fri, 24 Oct 2008 10:05:56 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211 rx filter in mesh mode, rt2x00 mesh point operation
Cc: "Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ivdoorn@gmail.com
In-Reply-To: <1224838921.6002.98.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4900f16b.0b0c360a.2bc3.ffffa11a@mx.google.com>
	 <445f43ac0810231507l790332b9h2c05e95aa0212392@mail.gmail.com>
	 <1224838921.6002.98.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Fri, Oct 24, 2008 at 2:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Javier,
>
> On Thu, 2008-10-23 at 15:07 -0700, Javier Cardona wrote:
>> Mesh frames have 4 addresses and no BSSID, so BSSID filtering should
>> be disabled (i.e. FIF_OTHER_BSS should be set).
>
> The BSSID is zeroed, right?

On data frames or multi-hop management frames there is no BSSID address.
On single-hop management frames the BSSID field is not used and set to
all zeros.

Cheers,

Javier
