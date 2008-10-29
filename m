Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:40001 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbYJ2TaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 15:30:17 -0400
Received: by fg-out-1718.google.com with SMTP id 19so160084fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 12:30:15 -0700 (PDT)
Message-ID: <45e8e6c40810291230r57357411yd62c857185fbae42@mail.gmail.com> (sfid-20081029_203022_920188_8B073DD3)
Date: Wed, 29 Oct 2008 12:30:15 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] ath9k: kill ath9k_opmode
Cc: linux-wireless@vger.kernel.org,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	Jouni.Malinen@atheros.com
In-Reply-To: <20081029192658.GD6103@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4907cc01.19f8720a.500d.6636@mx.google.com>
	 <20081029192658.GD6103@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I'll do that soon and send version 2.

On Wed, Oct 29, 2008 at 12:26 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Oct 28, 2008 at 07:35:45PM -0700, Andrey Yurovsky wrote:
>> This patch kills ath9k's ath9k_opmode enum by replacing it with nl80211_iftype.
>> Compile-tested only.
>
> Thanks, would it be possible for you to rebase on top of sujith's
> patches?
>
>  Luis
>
