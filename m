Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:4623 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbZENO1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 10:27:12 -0400
Received: by yw-out-2324.google.com with SMTP id 5so732740ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 07:27:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
References: <1241499867.4816.18.camel@maxim-laptop>
	 <43e72e890905121500k61545ff3mcdf099a08178b72c@mail.gmail.com>
	 <1242166051.26484.7.camel@maxim-laptop>
	 <43e72e890905131428r568e6f5eyd64566e993c83d8c@mail.gmail.com>
	 <1242256104.3241.4.camel@maxim-laptop>
	 <43e72e890905131612w275685d2tfe5066453b8b255e@mail.gmail.com>
	 <1242256950.3241.13.camel@maxim-laptop>
	 <43e72e890905131628i51255cd0wc16b7827a2514413@mail.gmail.com>
	 <1242258469.3241.19.camel@maxim-laptop>
	 <43e72e890905131707k2933f3cftfdec6e632f5b9fc3@mail.gmail.com>
Date: Thu, 14 May 2009 10:20:10 -0400
Message-ID: <b6c5339f0905140720p29be483cr1968f50a6bea48e5@mail.gmail.com>
Subject: Re: [BUG] Crda oopses the system
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 8:07 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>
>> I wish I had time to set up, an ath5k in AP mode. There are rumors that
>> it works more or less now, then I could use the same beacon frame to
>> test.
>
> It does and if it doesn't its a bug.

Just FYI, it's known to have problems if the STA uses power saving --
ath5k never updates the beacon.  I have a patch that should work in the
relevant bugzilla but I haven't been back to retest it (at first I
thought it was causing hangs, but later realized the hangs were due to
other bugs in w-t).

-- 
Bob Copeland %% www.bobcopeland.com
