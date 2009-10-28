Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51307 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbZJ1EQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 00:16:20 -0400
Received: by bwz27 with SMTP id 27so503933bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2009 21:16:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
References: <200910270259.09787.denys@visp.net.lb>
	 <43e72e890910261838k7986048dg4cc38634d828e98c@mail.gmail.com>
	 <200910270410.24274.denys@visp.net.lb>
	 <43e72e890910261959s6490b900xebb365d288c03f@mail.gmail.com>
Date: Wed, 28 Oct 2009 00:16:24 -0400
Message-ID: <b6c5339f0910272116o86419ber9c22def9ee52ddf7@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k, too high output power?
From: Bob Copeland <bcopeland@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Denys Fedoryschenko <denys@visp.net.lb>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 10:59 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> I mean A or B :-) AUX or MAIN :-)
>> Sorry for my ugly English.
>> In madwifi, as i remember i was possible to do that or over sysctl or over
>> module parameter, i dont remember exactly where.
>
> You mean can you do antenna diversity and select this manually ? I am
> not sure, but I doubt it, should be easy to add though.

The code's already there in the driver, there's just not any interface
to do it from cfg80211 yet.  If you want to hack the driver just look
for the antenna-related defines :)

-- 
Bob Copeland %% www.bobcopeland.com
