Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:50443 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828AbYLCUTZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 15:19:25 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1545437yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Dec 2008 12:19:23 -0800 (PST)
Message-ID: <43e72e890812031219t6a8c0d57hf54f376730a0655c@mail.gmail.com> (sfid-20081203_211941_084027_3D3FFF83)
Date: Wed, 3 Dec 2008 12:19:22 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [stable] [PATCH 1/3] ath9k: Handle -ENOMEM on RX gracefully
Cc: sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
	"Greg KH" <greg@kroah.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20081203002404.GA22789@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-3-git-send-email-lrodriguez@atheros.com>
	 <1228251082-11677-4-git-send-email-lrodriguez@atheros.com>
	 <20081203001253.GC14943@kroah.com>
	 <43e72e890812021620lccafachbd8e781d283095b7@mail.gmail.com>
	 <20081203002404.GA22789@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 4:24 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Tue, Dec 02, 2008 at 04:20:32PM -0800, Luis R. Rodriguez wrote:
>> On Tue, Dec 2, 2008 at 4:12 PM, Greg KH <greg@kroah.com> wrote:
>> > I don't see this patch upstream in Linus's tree.  Am I just missing it
>> > and if so, do you know the git commit id?
>>
>> Nope sorry, John has yet to send his pending-fixes branch to davem and
>> so forth, which would contain it AFAICT. Please correct me if I'm
>> wrong John.
>
> It has been sent, and Dave sent his pull request to Linus today
> (or maybe yesterday).  I'll try to dig-up the commit IDs tomorrow.

Greg, I see two of these patches in 2.6.27-stable review patch but the
one in this subject was not applied, any specific reason or was it
just missed?

  Luis
