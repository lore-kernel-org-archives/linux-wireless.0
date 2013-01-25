Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50589 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3AYIqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 03:46:33 -0500
Received: by mail-wi0-f172.google.com with SMTP id o1so1204689wic.5
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 00:46:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <EDAA1034-ABF9-4CC2-9055-2340462443AE@gmail.com>
References: <20130124205931.GB16252@localhost.localdomain>
	<EDAA1034-ABF9-4CC2-9055-2340462443AE@gmail.com>
Date: Fri, 25 Jan 2013 09:46:32 +0100
Message-ID: <CAGXE3d-_=PcT2nZq=TToSVXroMR0HOy+pbAoeMP7nxaYzKopYQ@mail.gmail.com> (sfid-20130125_094636_910824_0DE2910A)
Subject: Re: [PATCH 1/4] rt2x00: print warning, notice and info as default
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
	"John W. Linville" <linville@tuxdriver.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:06 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 24 jan. 2013, at 21:59, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
>
>> Some messages provide useful information, but are disabled without
>> CONFIG_RT2X00_DEBUG=y, so enable them by default
>>
>> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
>
> Thanks for respinning.

Fine with me, however, in the future we could think of just using
dynamic debug in rt2x00 (pr_debug etc). Would allow a user to
enable debug output selectively during runtime.

Helmut
