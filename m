Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:19472 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYHDPrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 11:47:17 -0400
Received: by an-out-0708.google.com with SMTP id d40so330901and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Aug 2008 08:47:16 -0700 (PDT)
Message-ID: <43e72e890808040847t777845f6uc37c21ebe0359821@mail.gmail.com> (sfid-20080804_174720_881894_9A4FC814)
Date: Mon, 4 Aug 2008 08:47:16 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH 4/4] ath9k: Add new Atheros IEEE 802.11n driver
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net,
	"Senthil Balasubramanian" <senthilkumar@atheros.com>,
	"Felix Fietkau" <nbd@openwrt.org>,
	"Jack Howarth" <howarth@bromo.msbb.uc.edu>,
	"Jouni Malinen" <jouni.malinen@atheros.com>,
	"Sujith Manoharan" <Sujith.Manoharan@atheros.com>,
	"Pavel Roskin" <proski@gnu.org>,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>
In-Reply-To: <20080804142321.GB9892@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1217834201-14680-1-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-2-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-3-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-4-git-send-email-lrodriguez@atheros.com>
	 <1217834201-14680-5-git-send-email-lrodriguez@atheros.com>
	 <20080804142321.GB9892@lst.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 4, 2008 at 7:23 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Aug 04, 2008 at 12:16:41AM -0700, Luis R. Rodriguez wrote:
>> This adds the new mac80211 11n ath9k Atheros driver. Only STA support
>> is currently enabled and tested.
>>
>> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> No signed off yet, I haven't even read in detail through the whole
> driver.  Same is probably true for most other people on this
> list.
>
> That beeing said I'm not really in a position to sign off either as
> I'm not the mainter nor a major contributor to the patch.

Sorry I had meant you had patches in with your name. Just wanted to
provide credit for that, that's all.

  Luis
