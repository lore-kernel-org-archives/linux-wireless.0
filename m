Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33792 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751291AbdCAS4s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Mar 2017 13:56:48 -0500
Received: by mail-io0-f176.google.com with SMTP id 90so37684372ios.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Mar 2017 10:55:05 -0800 (PST)
Date: Wed, 1 Mar 2017 08:59:38 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ryan Mounce <ryan@mounce.com.au>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] wireless-regdb: Update rules for Australia (AU) and
 add 60GHz rules
Message-ID: <20170301145938.GK122517@ubuntu-hedt> (sfid-20170301_195657_202476_1DC0AE5D)
References: <20170224145519.GD3479@ubuntu-hedt>
 <20170225031027.7871-1-ryan@mounce.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170225031027.7871-1-ryan@mounce.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 25, 2017 at 01:40:27PM +1030, Ryan Mounce wrote:
> Sourced from the current legislation at
> https://www.legislation.gov.au/Details/F2016C00432
> 
> The current rules exceed legal limits between 5250-5330MHz, and permit
> illegal operation in 5600-5650MHz (disallowed regardless of DFS).
> 
> Frequency ranges and EIRP limits for all ranges have been updated to
> match items 59-63, 65 in the linked document. As the rules for AU have
> never previously mirrored local regulations, changes include a
> significant increase in the allowable 2.4GHz EIRP and smaller increases
> in most other bands.
> 
> In order to allow 80MHz operation between 5650-5730MHz (bordering two
> bands) the lower, more restrictive band has been rounded up by 5MHz.
> 
> Signed-off-by: Ryan Mounce <ryan@mounce.com.au>

This looks good to me. I'll give it a few more days to see if anyone
else has comments.

Thanks,
Seth
