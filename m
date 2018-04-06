Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:40881 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751344AbeDFIMB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:12:01 -0400
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <871sftemru.fsf@kamboji.qca.qualcomm.com>
 <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
 <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
 <1d917688-9f59-39ad-46a6-527d9e3dec03@dd-wrt.com>
 <87d0zcsqmv.fsf@codeaurora.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <41fa794e-d5d5-004e-5403-1e14c77a567a@dd-wrt.com> (sfid-20180406_101206_456759_8FDEF918)
Date: Fri, 6 Apr 2018 10:11:59 +0200
MIME-Version: 1.0
In-Reply-To: <87d0zcsqmv.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.04.2018 um 10:09 schrieb Kalle Valo:
> (adding back the lists, please don't top post and trim your quotes)
>
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> okay. ath10k-check is buggy and doesnt work. so it doesnt help much
>> with code styles
>>
>> root@seg-desktop:/xfs/ath10k/ath.gpio# ./ath10k-check
>> global: 'drivers/net/wireless/ath/ath10k/Kconfig' is not a source file.
>> Traceback (most recent call last):
>>    File "./ath10k-check", line 461, in <module>
>>      main()
>>    File "./ath10k-check", line 455, in main
>>      ret = run_checkpatch(args)
>>    File "./ath10k-check", line 275, in run_checkpatch
>>      output = subprocess.check_output(cmd, shell=True)
>>    File "/usr/lib/python2.7/subprocess.py", line 219, in check_output
>>      raise CalledProcessError(retcode, cmd, output=output)
>> subprocess.CalledProcessError: Command 'global -f
>> drivers/net/wireless/ath/ath10k/Kconfig' returned non-zero exit status 1
> You are missing gtags, see 'ath10k-check --help' for how to install:
>
> Requirements (all available in $PATH):
>
> * gcc
> * sparse
> * checkpatch.pl
> * gtags (from package global)
ahm i did read this and this was all installed. but ath10k-check refuses 
to work

root@seg-desktop:/home/seg/DEV# gtags --version
gtags (GNU GLOBAL) 6.5.7
Copyright (c) 1996-2017 Tama Communications Corporation
License GPLv3+: GNU GPL version 3 or later 
<http://www.gnu.org/licenses/gpl.html>
This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
