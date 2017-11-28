Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:37864 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdK1IgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Nov 2017 03:36:03 -0500
Date: Tue, 28 Nov 2017 14:05:55 +0530
From: Morgan Freeman <morganfreeman6991@gmail.com>
To: Ashish Kalra <eashishkalra@gmail.com>
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drivers: bcma: driver_pcie2.c: Comment format
 correction & moving trailing */ to a separate line  as per checkpatch
Message-ID: <20171128083555.GA2807@himanshu-Vostro-3559> (sfid-20171128_093640_523632_972677B0)
References: <20171126172747.GA6512@himanshu-Vostro-3559>
 <20171128021142.2793-1-eashishkalra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171128021142.2793-1-eashishkalra@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ashish,

On Tue, Nov 28, 2017 at 07:41:42AM +0530, Ashish Kalra wrote:
> This patch fixes the checkpatch.pl warning:

Write in _imperative_mood_ as I said before.
Like "Use this..." or "Make this..."


> WARNING: Block comments use * on subsequent lines
> +		/* TODO:
> +		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */
> 
> WARNING: Block comments use a trailing */ on a separate line
> +		si_core_wrapperreg(pcie2, 3, 0x60, 0x8080, 0); */
> 
> total: 0 errors, 2 warnings, 200 lines checked

No need to mention all of this!

> Signed-off-by: Ashish Kalra <eashishkalra@gmail.com>
> ---
> changes from v1 (https://lkml.org/lkml/2017/11/26/85)
> v2: Improved commit message as per review from Morgan Freeman <morganfreeman6991@gmail.com>

Your patch subject is again *wrong* here.

Look here: https://pastebin.com/X7x89Q4v

Please take a look at this :
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Also, don't send me the patch directly, instead to the relevant maintainer and
CC me.


Thanks
Himanshu Jha
