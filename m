Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55580 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0JZGpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 02:45:22 -0400
Received: by wyf28 with SMTP id 28so4251766wyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 23:45:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010261539.34710.br1@einfach.org>
References: <AANLkTinqLcr7OpQZijX70aVE_P8gpUp=6RkozzVZH5Fm@mail.gmail.com> <201010261539.34710.br1@einfach.org>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Tue, 26 Oct 2010 16:44:35 +1000
Message-ID: <AANLkTimKpBCr1sJvZyvCzScacup8DmVxNKzWBmLFRCya@mail.gmail.com>
Subject: Re: Access Channel Utilization
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 26, 2010 at 4:39 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Tue October 26 2010 15:24:42 Jonathan Guerin wrote:
>> Hi,
>>
>> I'm trying to access the phy-layer stats that were recently added to
>> cfg80211 and nl80211. I'm using a modified version of iw as per this
>> patch:
>> https://dev.openwrt.org/browser/trunk/package/iw/patches/110-survey_phy_sta
>> ts.patch
>>
>> Unfortunately, the utilization stats don't appear to be getting sent
>> back. I'm using ath5k as the underlying driver.
>
> are you missing this patch?
>
> "ath5k: Add channel time to survey data"
> https://patchwork.kernel.org/patch/264831/

commit ebe5fd859224e706e0c027e1d6c3859684ae41fe
Author: John W. Linville <linville@tuxdriver.com>
Date:   Thu Oct 21 13:43:56 2010 -0400

    Revert "ath5k: Add channel time to survey data"

    This reverts commit 2f5155b69eca2a62a5defb15762019486a638a88.

Ah - the patch was reverted. Any reason why this was done?

>
> bruno
>
