Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:26492 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYLQRk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 12:40:58 -0500
Received: by yx-out-2324.google.com with SMTP id 8so3441yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 09:40:57 -0800 (PST)
Message-ID: <b6c5339f0812170940x58612431ufbe4248711573552@mail.gmail.com> (sfid-20081217_184103_240507_9D473F88)
Date: Wed, 17 Dec 2008 12:40:56 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath5k: Updated padding stuff for the RX and TX side. TX side has been 100%
Cc: "Benoit PAPILLAULT" <benoit.papillault@free.fr>,
	"Jouni Malinen" <j@w1.fi>, linux-wireless@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <20081217155533.GB12679@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229351698-21116-1-git-send-email-benoit.papillault@free.fr>
	 <20081215170613.GA22627@jm.kir.nu> <4946C6D9.1060101@free.fr>
	 <b6c5339f0812160722nab8516cj1ed4e6d397060d9d@mail.gmail.com>
	 <20081217155533.GB12679@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 10:55 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Dec 16, 2008 at 10:22:39AM -0500, Bob Copeland wrote:
>> Well, anyway John already picked up your earlier (better, IMHO) patch.
>> Now we just need to fix the tx descriptors :)
>
> Based on that comment, I'm dropping this version of the patch.
> Feel free to submit additional patches to implement whatever might
> be missing now.

Okay. I think the one you took before, plus my diff should be sufficient.
Do you want me to submit a proper patch that just fixes the TX, or should
we regroup and combine both up into a single patch on our side?

Either way I'll give it a little testing tonight to make sure we didn't
miss anything.

-- 
Bob Copeland %% www.bobcopeland.com
