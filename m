Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37742 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754326AbeDBKmp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Apr 2018 06:42:45 -0400
Message-ID: <1522665761.3786.365.camel@coelho.fi> (sfid-20180402_124249_647955_57842AD7)
From: Luca Coelho <luca@coelho.fi>
To: Nye Liu <nyet@nyet.org>, linux-wireless@vger.kernel.org
Date: Mon, 02 Apr 2018 13:42:41 +0300
In-Reply-To: <423cffeb-fabc-78fc-c2f6-7d9e226fc051@nyet.org>
References: <423cffeb-fabc-78fc-c2f6-7d9e226fc051@nyet.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi: completely opaque WARN_ON(1) at
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363. Please remove or fix it
 (TX_STATUS_FAIL_DEST_PS)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please report this as a bug in the kernel bugzilla[1] and provide the
logs as explained in our wiki[2].

[1] https://bugzilla.kernel.org/
[2] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging

Thanks.

--
Luca.

On Mon, 2018-04-02 at 02:44 -0700, Nye Liu wrote:
> TX_STATUS_FAIL_DEST_PS
> 
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=887045
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1733194
> 
> Please remove or fix the WARN_ON(1) at 
> drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1363 it is filling my
> kernel 
> logs
> 
