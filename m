Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49522 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab1EaSQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 14:16:32 -0400
Received: by qyg14 with SMTP id 14so2562465qyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2011 11:16:32 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <86ipsqkcag.fsf@coulee.tdb.com>
References: <861v0igqhn.fsf@coulee.tdb.com>
	<86iptq8r8w.fsf@coulee.tdb.com>
	<4DC1671C.9040906@openwrt.org>
	<86liyjjo0a.fsf@coulee.tdb.com>
	<86ipsqkcag.fsf@coulee.tdb.com>
Date: Tue, 31 May 2011 20:16:31 +0200
Message-ID: <BANLkTi=TagYFb5WG7MzTgx_LMD_roDQx4g@mail.gmail.com> (sfid-20110531_201636_692793_746D4E72)
Subject: Re: [ath5k-devel] kernel panic on MIPS + ath5k + Wistron CM9 radio
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Russell Senior <russell@personaltelco.net>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2011 at 7:30 PM, Russell Senior
<russell@personaltelco.net> wrote:
>>>>>> "Russell" == Russell Senior <seniorr@aracnet.com> writes:
>
> Russell> I just confirmed Peizhao Hu's observation.  The CM9's with
> Russell> chips marked AR5213A-001 panic on MIPS.  CM9's with chips
> Russell> marked AR5213A-00 do not.  It looks like (from my small
> Russell> sample immediately at hand) the stock radios on Netgear
> Russell> WGT634U also are marked AR5213A-00, and don't seem to panic.
>
> Seems to be fixed in OpenWrt r27024.  Thanks Felix!
>
>  https://dev.openwrt.org/changeset/27024/
>
>
> --
> Russell Senior, President
> russell@personaltelco.net
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Just FYI:
Nick sent the patch from [1] to linux-wireless ML a few weeks ago.

- Sedat -

[1] http://www.kernel.org/pub/linux/kernel/people/mickflemm/01-fast-chan-switch-modparm
