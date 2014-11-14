Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:40142 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaKNAJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 19:09:01 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so11012obc.20
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 16:09:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zje528im.fsf@kamboji.qca.qualcomm.com>
References: <20140910152136.12610.18499.stgit@potku.adurom.net> <87zje528im.fsf@kamboji.qca.qualcomm.com>
From: Pushpal Sidhu <psidhu@gateworks.com>
Date: Thu, 13 Nov 2014 16:08:30 -0800
Message-ID: <CAD1M061Gky-a28Rokmgyd-5x_m_h1SNmj9ZxUd4v1fP=bae35g@mail.gmail.com> (sfid-20141114_010905_726901_62FF04B7)
Subject: Re: [PATCH v4 0/2] ath10k: testmode support
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2014 at 1:43 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Kalle Valo <kvalo@qca.qualcomm.com> writes:
>
>> latest version of my testmode patches. Getting closer, more or less cosmetic
>> changes this time :)

While looking through this patchset (sorry it took two months), I have
to wonder: what's this utf.bin blob? It seems in order to use
testmode, we need this binary blob that I can't seem to find (I looked
in linux-firmware and https://github.com/kvalo/ath10k-firmware). If,
for whatever reason, this binary blob is not releasable, what's the
point of adding in testmode to this driver?

- Pushpal
