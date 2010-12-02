Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward3.mail.yandex.net ([77.88.46.8]:34673 "EHLO
	forward3.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab0LBJuI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 04:50:08 -0500
From: Misha Shnurapet <shnurapet@fedoraproject.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: rajkumar.manoharan@atheros.com, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin+DzagZ7OhkbGoxR2bJyYcYSoEnz2FavD6VR=P@mail.gmail.com>
References: <740581291208091@web69.yandex.ru>
	<AANLkTimupT+zROY0-LB5i8MoVj+72cE14L-R2wEEdif9@mail.gmail.com>
	<20101201162107.GA16381@vmraj-lnx.users.atheros.com> <AANLkTin+DzagZ7OhkbGoxR2bJyYcYSoEnz2FavD6VR=P@mail.gmail.com>
Subject: Re: [ath9k-devel] Netgear WNA1100 and master mode
MIME-Version: 1.0
Message-Id: <183971291283028@web55.yandex.ru>
Date: Thu, 02 Dec 2010 17:43:48 +0800
Content-Type: text/plain; charset=koi8-r
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

02.12.2010, 12:28, "Mohammed Shafi" <shafi.wireless@gmail.com>:
> On Wed, Dec 1, 2010 at 9:51 PM, Rajkumar Manoharan
> <rmanoharan@atheros.com>; wrote:
>
>> šOn Wed, Dec 01, 2010 at 06:44:15PM +0530, Mohammed Shafi wrote:
>>> šOn Wed, Dec 1, 2010 at 6:24 PM, Misha Shnurapet
>>> š<shnurapet@fedoraproject.org>; wrote:
>>>> šHi.
>>>>
>>>> šDoes Netgear WNA1100 USB adapter support master mode?
>>> šYes , you have to use hostapd for that.you cannot use iwconfig command
>>> što set it as a master mode.
>
> Sorry for the wrong information.
>
>> šHi Misha,
>>
>> šath9k_htc does not support AP mode as of now. we are working on it. To enable
>> šAP mode support for ath9k_htc use the follwoing patch
>>
>> šhttps://patchwork.kernel.org/patch/106640/

Thanks a lot for the information, it would rather be hard to figure out.

If there is a Bugzilla thread for me to subscribe to watch the issue, I would appreciate the link.

-- 
Best regards,
Misha Shnurapet, Fedora Project Contributor
http://fedoraproject.org/wiki/User:Shnurapet
shnurapet AT fedoraproject.org, GPG: 00217306
