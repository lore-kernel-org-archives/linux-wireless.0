Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34891 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755781AbcJVTRg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 15:17:36 -0400
Received: by mail-wm0-f49.google.com with SMTP id c78so39357405wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Oct 2016 12:17:35 -0700 (PDT)
Subject: Re: [PATCH v3 3/9] cfg80211: add add_nan_func / del_nan_func
To: johannes@sipsolutions.net
References: <20160920143121.28247-1-luca@coelho.fi>
 <20160920143121.28247-4-luca@coelho.fi>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        ayala.beker@intel.com, andrei.otcheretianski@intel.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6fb30815-b8c8-aff4-86af-d7f496da91b5@broadcom.com> (sfid-20161022_211738_254386_517227D5)
Date: Sat, 22 Oct 2016 21:17:20 +0200
MIME-Version: 1.0
In-Reply-To: <20160920143121.28247-4-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-09-16 16:31, Luca Coelho wrote:
> +		.flags = GENL_ADMIN_PERM,

Hi Johannes,

Recently the nl80211_ops flags were changed to GENL_UNS_ADMIN_PERM so
should the NAN commands use that as well?

Regards,
Arend
