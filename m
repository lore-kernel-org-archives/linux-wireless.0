Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62848 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab0CJUiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 15:38:17 -0500
Received: by pwj5 with SMTP id 5so472684pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Mar 2010 12:38:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268195656.10669.37.camel@mj>
References: <20100310035408.28564.65912.stgit@mj.roinet.com>
	<20100310035414.28564.10870.stgit@mj.roinet.com> <1268195656.10669.37.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 10 Mar 2010 12:37:55 -0800
Message-ID: <43e72e891003101237o4ab63061h8a037c6d047e5c3e@mail.gmail.com>
Subject: Re: [PATCH 2/2] compat-wireless: disable wl12xx if crc7 is not
	available
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 9, 2010 at 8:34 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Tue, 2010-03-09 at 22:54 -0500, Pavel Roskin wrote:
>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>> ---
>>  config.mk |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> Please disregards this patch, it goes too far.  wl1251_sdio still can be
> compiled without crc7().
>
> That's the second version (RFC):
>
>
> compat-wireless: disable wl1251 SPI and wl1271 if crc7 is not available
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks! Applied your other one and this new iteration of this patch.

  Luis
