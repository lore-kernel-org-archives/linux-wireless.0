Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:38505 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYJEBCg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 21:02:36 -0400
Received: by gxk9 with SMTP id 9so3903320gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 04 Oct 2008 18:02:35 -0700 (PDT)
Message-ID: <43e72e890810041802w5091a941ma781b8b40f8b5672@mail.gmail.com> (sfid-20081005_030243_069731_1AC3B516)
Date: Sat, 4 Oct 2008 18:02:34 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH 4/5] ath5k: Fix SREV reporting after SREV updates
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, nbd@openwrt.org
In-Reply-To: <20081005003710.GA3222@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080928222444.GD21335@makis>
	 <20081005003710.GA3222@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 4, 2008 at 5:37 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Mon, Sep 29, 2008 at 01:24:44AM +0300, Nick Kossifidis wrote:
>>  * Fix srev reporting during attach
>>
>>  Changes-Licensed-under: ISC
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> This now identifies my card as 5414, whereas ath5k used to call it 5424
> (mac srev 0xa3, phy 0x61).
>
> But, madwifi has:
>  #define AR5K_SREV_VER_AR5424     0xa3 /* PCI-E */
>
> It still works so not a major problem, but who's right?

Since legacy-hal.tar.bz2 comes directly from our latest codebase I
expect that to have the latest correct information. If there are
doubts that is another thing and we can look into it.

  Luis
