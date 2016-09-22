Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50123 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965268AbcIVVBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Sep 2016 17:01:36 -0400
Date: Thu, 22 Sep 2016 23:01:32 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
Message-ID: <20160922230132.5aa36918@endymion> (sfid-20160922_230147_361375_B54AD236)
In-Reply-To: <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
References: <20160922115116.149c599c@endymion>
        <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Thu, 22 Sep 2016 10:09:58 -0500, Larry Finger wrote:
> Do you build your own kernel, or are you using openSUSE's supplied version? If 
> the latter, I will need to think how we might debug the issue. If the former, 
> please add the attached patch.

The debug module is in place. The error message was logged 3 times
today, so I should have some data for you tomorrow.

Thanks,
-- 
Jean Delvare
SUSE L3 Support
