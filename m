Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38859 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab0LBE2v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 23:28:51 -0500
Received: by wyb28 with SMTP id 28so7754623wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 20:28:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101201162107.GA16381@vmraj-lnx.users.atheros.com>
References: <740581291208091@web69.yandex.ru>
	<AANLkTimupT+zROY0-LB5i8MoVj+72cE14L-R2wEEdif9@mail.gmail.com>
	<20101201162107.GA16381@vmraj-lnx.users.atheros.com>
Date: Thu, 2 Dec 2010 09:58:49 +0530
Message-ID: <AANLkTin+DzagZ7OhkbGoxR2bJyYcYSoEnz2FavD6VR=P@mail.gmail.com>
Subject: Re: [ath9k-devel] Netgear WNA1100 and master mode
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: shnurapet@fedoraproject.org
Cc: Rajkumar.Manoharan@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 9:51 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> On Wed, Dec 01, 2010 at 06:44:15PM +0530, Mohammed Shafi wrote:
>> On Wed, Dec 1, 2010 at 6:24 PM, Misha Shnurapet
>> <shnurapet@fedoraproject.org> wrote:
>> > Hi.
>> >
>> > Does Netgear WNA1100 USB adapter support master mode?
>>
>> Yes , you have to use hostapd for that.you cannot use iwconfig command
>> to set it as a master mode.

Sorry for the wrong information.
>> >
> Hi Misha,
>
> ath9k_htc does not support AP mode as of now. we are working on it. To enable
> AP mode support for ath9k_htc use the follwoing patch
>
> https://patchwork.kernel.org/patch/106640/
>
> --
> Rajkumar
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
