Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:4655 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061AbYKCWsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:48:20 -0500
Received: by an-out-0708.google.com with SMTP id d40so138192and.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:48:18 -0800 (PST)
Message-ID: <b6c5339f0811031448hc264513v76b25e7cf93ea388@mail.gmail.com> (sfid-20081103_234825_685532_07C5CB14)
Date: Mon, 3 Nov 2008 17:48:18 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: Fix IMR init
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
In-Reply-To: <20081103224425.GC6378@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081103222554.GA3006@makis> <20081103224425.GC6378@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 5:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Nov 03, 2008 at 02:25:54PM -0800, Nick Kossifidis wrote:
>>  PISR) and under load it results packet loss. Fix the problem by
>>  unmasking TXDESC and TXEOL on ath5k_init.
>>
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> ACK

Yes, please - worked great here.

-- 
Bob Copeland %% www.bobcopeland.com
