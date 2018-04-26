Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:41495 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752305AbeDZEwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 00:52:51 -0400
Received: by mail-io0-f177.google.com with SMTP id e12-v6so6503489iob.8
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2018 21:52:51 -0700 (PDT)
Subject: Re: [linuxwifi] Simultaneous 2.4 GHz WiFi and Bluetooth issue on
 Intel Dual Band Wireless-AC 8260
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
References: <6e4b5e53-0a8d-978c-5cfe-f498c8b15c1a@gmail.com>
 <CANUX_P19ja=XLMs8Vvii1yMvCNAvPnMh7hs=H92M5QRJnJjRfg@mail.gmail.com>
 <30aa1580-7913-a7f8-3f2d-be4d699d6dbc@gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB30126BF90DA@HASMSX112.ger.corp.intel.com>
From: Nathan Schulte <nmschulte@gmail.com>
Message-ID: <ecc3e8ac-78c8-2f6e-e252-95f2b1dc1ba3@gmail.com> (sfid-20180426_065256_097098_A6494179)
Date: Wed, 25 Apr 2018 23:52:49 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB30126BF90DA@HASMSX112.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2018 12:22 AM, Grumbach, Emmanuel wrote:
>> This seems to have resolved the issue.  Interestingly, the firmware
>> (version...) shipped with Debian Sid is not in the official linux-firmware.git
>> repository; its md5sum doesn't match any of prior versions of the file:
> 
> Glad to know. I guess you can open a bug on Debian to thave they fix this.
> This is rather strange though.

I re-verified this, and I must have done something wrong the first go
around.  It looks like the last commit in the log for the file is indeed
what's packaged.

--
Nate
