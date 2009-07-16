Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:39208 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbZGPUgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 16:36:15 -0400
MIME-Version: 1.0
In-Reply-To: <200907162227.30362.IvDoorn@gmail.com>
References: <1247734839-21394-1-git-send-email-klto@zhaw.ch>
	<200907162227.30362.IvDoorn@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 16 Jul 2009 13:35:54 -0700
Message-ID: <43e72e890907161335m4a6b6e7cx1aa945181eb408e3@mail.gmail.com>
Subject: Re: [PATCH 7/8] rt2x00: Use %pM conversion specifier
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tobias Klauser <klto@zhaw.ch>, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 16, 2009 at 1:27 PM, Ivo van Doorn<ivdoorn@gmail.com> wrote:
> On Thursday 16 July 2009, Tobias Klauser wrote:
>> Use the %pM conversion specifier for printk instead of print_mac.
>>
>> Signed-off-by: Tobias Klauser <klto@zhaw.ch>
>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Johannes already has a patch for this posted which takes care of all of these.

http://marc.info/?l=linux-wireless&m=124767211929848&w=2

  Luis
