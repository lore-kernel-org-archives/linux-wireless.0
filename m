Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38449 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759501AbcIRTnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 15:43:15 -0400
Received: by mail-wm0-f41.google.com with SMTP id 1so124804909wmz.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2016 12:43:14 -0700 (PDT)
Subject: Re: [PATCH v2 4/9] cfg80211: allow the user space to change current
 NAN configuration
To: Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net
References: <20160916083321.5840-1-luca@coelho.fi>
 <20160916083321.5840-5-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Ayala Beker <ayala.beker@intel.com>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6a81754d-ff9f-9f79-d7d0-9d5431f681ac@broadcom.com> (sfid-20160918_214337_326032_6BFE7BC0)
Date: Sun, 18 Sep 2016 21:43:02 +0200
MIME-Version: 1.0
In-Reply-To: <20160916083321.5840-5-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16-9-2016 10:33, Luca Coelho wrote:
> From: Ayala Beker <ayala.beker@intel.com>
> 
> Some NAN configuration paramaters may change during the operation of
> the NaN device. For example, a user may want to update master preference

typo: NAN iso NaN.

Regards,
Arend
