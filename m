Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64041 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3JJCGY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Oct 2013 22:06:24 -0400
Received: by mail-lb0-f172.google.com with SMTP id x18so1530479lbi.31
        for <linux-wireless@vger.kernel.org>; Wed, 09 Oct 2013 19:06:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52556024.20302@rempel-privat.de>
References: <CAJqaZwy4priN+Zjnejvj2bbpBm6wN_smSZZi5FBSNrbDaLgiGw@mail.gmail.com>
	<52556024.20302@rempel-privat.de>
Date: Wed, 9 Oct 2013 19:06:22 -0700
Message-ID: <CAJqaZwybHqWohkJu-=0FwWGk0Vkam9-8vbdG=uG0xRVxkLA+ww@mail.gmail.com> (sfid-20131010_040628_091008_2E527689)
Subject: Re: [mac80211] connection drop up to 20x/hour at office
From: ASIC Felix <ic.felix@gmail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 9, 2013 at 6:54 AM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 09.10.2013 06:29, schrieb ASIC Felix:
>> I get this connection drop several times an hour, at office up to
>> 20x/hour, with current Ubuntu Kernel + Backports wifi even at home,
>> before only at the office. Wifi connection recovers eventually, but
>> breaks VM and often even VPN connections.
>
> 20x per hour? it mean each 3 mints. Hmm... looks like scan interval of
> wpa_supplicant.
> Is it possible to change time to live setting of access point?

I'm the only one with an issue, everyone else uses windoz with intel
wifi and their connection remains solid.

Felix
