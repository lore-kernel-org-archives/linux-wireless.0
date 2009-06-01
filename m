Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61226 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbZFAQg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 12:36:57 -0400
Received: by bwz22 with SMTP id 22so7584340bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 09:36:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090414105200.GE25746@storm.local.network>
References: <20090414105200.GE25746@storm.local.network>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 1 Jun 2009 18:35:35 +0200
Message-ID: <69e28c910906010935n28f69921xd589a945e982ca1@mail.gmail.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
To: Forest Bond <forest@alittletooquiet.net>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 14, 2009 at 12:52 PM, Forest Bond
<forest@alittletooquiet.net> wrote:
> This patch adds the vt6656 driver to drivers/staging.  This code was literally
> copied from the upstream source archive, available here:
>
>  http://www.viaarena.com/Driver/VT6656_Linux_src_v1.19_12_x86.zip
>
> Copyright: VIA Networking Technologies, Inc.
> License: GPL
> Authors: Jerry Chen, Kyle Hsu, Lucas Lin, Lyndon Chen, Tevin Chen, Warren Hsu,
>         Yiching Chen
> Signed-off-by: Forest Bond <forest@alittletooquiet.net>
>
> Patch: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz
> Signature: http://www.alittletooquiet.net/media/code/0002-Add-vt6656-driver-to-drivers-staging.patch.gz.sig
>
> Thanks,
> Forest
> --
> Forest Bond
> http://www.alittletooquiet.net
> http://www.pytagsfs.org
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFJ5GrQRO4fQQdv5AwRAjRIAKDb73oGJyViwov/yvUomOTKCeQC7wCeJ1Tr
> Sq8Nqu8rIJI/wL7AlIyyRv0=
> =cloX
> -----END PGP SIGNATURE-----
>
>

Did this patch (along with the vt6655 one) somehow get lost? I can't
see it in drivers/staging.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
