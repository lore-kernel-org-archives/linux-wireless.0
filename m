Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47180 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757047Ab3GEJFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 05:05:41 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so4679995iee.6
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jul 2013 02:05:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130703191417.GA2245@localhost.localdomain>
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
	<1372269318-30233-2-git-send-email-juhosg@openwrt.org>
	<20130703191417.GA2245@localhost.localdomain>
Date: Fri, 5 Jul 2013 11:05:40 +0200
Message-ID: <CAGXE3d_gzUhgXvjDg9HacNwO_TKmixhmz1RB7vpfm28eBuK13A@mail.gmail.com> (sfid-20130705_110544_770597_34D55692)
Subject: Re: [rt2x00-users] [PATCH 1/5] rt2x00: rt2800lib: introduce
 rt2800_eeprom_word enum
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 3, 2013 at 9:14 PM, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> On Wed, Jun 26, 2013 at 07:55:14PM +0200, Gabor Juhos wrote:
>> The patch converts the EEPROM_* word address defines
>> into new enum values. The new enum type will be used
>> by new functions which will be introduced in subsequent
>> changes.
>>
>> The patch contains no functional changes.
>>
>> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

Nice! Just had a quick glance at the series. Looks good to me.

Thanks,
Helmut
