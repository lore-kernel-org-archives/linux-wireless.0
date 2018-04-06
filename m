Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750815AbeDFIJR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:09:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for various chipsets
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
        <871sftemru.fsf@kamboji.qca.qualcomm.com>
        <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
        <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
        <1d917688-9f59-39ad-46a6-527d9e3dec03@dd-wrt.com>
Date: Fri, 06 Apr 2018 11:09:12 +0300
In-Reply-To: <1d917688-9f59-39ad-46a6-527d9e3dec03@dd-wrt.com> (Sebastian
        Gottschall's message of "Thu, 5 Apr 2018 22:27:18 +0200")
Message-ID: <87d0zcsqmv.fsf@codeaurora.org> (sfid-20180406_100922_659651_12AE535D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding back the lists, please don't top post and trim your quotes)

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> okay. ath10k-check is buggy and doesnt work. so it doesnt help much
> with code styles
>
> root@seg-desktop:/xfs/ath10k/ath.gpio# ./ath10k-check
> global: 'drivers/net/wireless/ath/ath10k/Kconfig' is not a source file.
> Traceback (most recent call last):
> =C2=A0 File "./ath10k-check", line 461, in <module>
> =C2=A0=C2=A0=C2=A0 main()
> =C2=A0 File "./ath10k-check", line 455, in main
> =C2=A0=C2=A0=C2=A0 ret =3D run_checkpatch(args)
> =C2=A0 File "./ath10k-check", line 275, in run_checkpatch
> =C2=A0=C2=A0=C2=A0 output =3D subprocess.check_output(cmd, shell=3DTrue)
> =C2=A0 File "/usr/lib/python2.7/subprocess.py", line 219, in check_output
> =C2=A0=C2=A0=C2=A0 raise CalledProcessError(retcode, cmd, output=3Doutput)
> subprocess.CalledProcessError: Command 'global -f=20
> drivers/net/wireless/ath/ath10k/Kconfig' returned non-zero exit status 1

You are missing gtags, see 'ath10k-check --help' for how to install:

Requirements (all available in $PATH):

* gcc
* sparse
* checkpatch.pl
* gtags (from package global)

--=20
Kalle Valo
