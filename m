Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34105 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdFVHpa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 03:45:30 -0400
Received: by mail-qk0-f170.google.com with SMTP id d14so5900693qkb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 00:45:30 -0700 (PDT)
Subject: Re: cfg80211_ops
To: Johannes Berg <johannes@sipsolutions.net>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "Tobin C. Harding" <me@tobin.cc>, linux-wireless@vger.kernel.org
References: <20170622000347.GA15458@eros>
 <a3105fed-a02b-cd0e-1f4a-e3f9a0b7dd1f@quantenna.com>
 <1498113028.2246.4.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <61ef2e4d-5b3f-f839-b097-495713cb290f@broadcom.com> (sfid-20170622_094534_459066_EE85853A)
Date: Thu, 22 Jun 2017 09:45:26 +0200
MIME-Version: 1.0
In-Reply-To: <1498113028.2246.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-06-17 08:30, Johannes Berg wrote:
> Also, set_default_key is, IIRC, not needed in WPA/WPA2 client mode, but
> may be needed for WEP - not sure off the top of my head.

correct (if brcmfmac is).

Gr. AvS
