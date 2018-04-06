Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48096 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbeDFIZe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:25:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for various chipsets
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
        <871sftemru.fsf@kamboji.qca.qualcomm.com>
        <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
        <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
        <1d917688-9f59-39ad-46a6-527d9e3dec03@dd-wrt.com>
        <87d0zcsqmv.fsf@codeaurora.org>
        <41fa794e-d5d5-004e-5403-1e14c77a567a@dd-wrt.com>
Date: Fri, 06 Apr 2018 11:25:29 +0300
In-Reply-To: <41fa794e-d5d5-004e-5403-1e14c77a567a@dd-wrt.com> (Sebastian
        Gottschall's message of "Fri, 6 Apr 2018 10:11:59 +0200")
Message-ID: <87sh88rbba.fsf@codeaurora.org> (sfid-20180406_102539_992516_F8BD96FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 06.04.2018 um 10:09 schrieb Kalle Valo:
>> (adding back the lists, please don't top post and trim your quotes)
>>
>> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>>
>>> okay. ath10k-check is buggy and doesnt work. so it doesnt help much
>>> with code styles
>>>
>>> root@seg-desktop:/xfs/ath10k/ath.gpio# ./ath10k-check
>>> global: 'drivers/net/wireless/ath/ath10k/Kconfig' is not a source file.
>>> Traceback (most recent call last):
>>>  =C2=A0 File "./ath10k-check", line 461, in <module>
>>>  =C2=A0=C2=A0=C2=A0 main()
>>>  =C2=A0 File "./ath10k-check", line 455, in main
>>>  =C2=A0=C2=A0=C2=A0 ret =3D run_checkpatch(args)
>>>  =C2=A0 File "./ath10k-check", line 275, in run_checkpatch
>>>  =C2=A0=C2=A0=C2=A0 output =3D subprocess.check_output(cmd, shell=3DTru=
e)
>>>  =C2=A0 File "/usr/lib/python2.7/subprocess.py", line 219, in check_out=
put
>>>  =C2=A0=C2=A0=C2=A0 raise CalledProcessError(retcode, cmd, output=3Dout=
put)
>>> subprocess.CalledProcessError: Command 'global -f
>>> drivers/net/wireless/ath/ath10k/Kconfig' returned non-zero exit status 1
>>
>> You are missing gtags, see 'ath10k-check --help' for how to install:
>>
>> Requirements (all available in $PATH):
>>
>> * gcc
>> * sparse
>> * checkpatch.pl
>> * gtags (from package global)
>
> ahm i did read this and this was all installed. but ath10k-check
> refuses to work
>
> root@seg-desktop:/home/seg/DEV# gtags --version
> gtags (GNU GLOBAL) 6.5.7
> Copyright (c) 1996-2017 Tama Communications Corporation
> License GPLv3+: GNU GPL version 3 or later
> <http://www.gnu.org/licenses/gpl.html>
> This is free software; you are free to change and redistribute it.
> There is NO WARRANTY, to the extent permitted by law.

Damn, I guess something has changed in gtags as I use older version:

gtags - GNU GLOBAL 5.7.1

--=20
Kalle Valo
