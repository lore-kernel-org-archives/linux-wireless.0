Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38711 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755446AbdCGNUB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 08:20:01 -0500
Received: by mail-it0-f43.google.com with SMTP id m27so3002516iti.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Mar 2017 05:19:55 -0800 (PST)
Date: Tue, 7 Mar 2017 07:11:56 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Ryan Mounce <ryan@mounce.com.au>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] wireless-regdb: Update rules for Australia (AU) and
 add 60GHz rules
Message-ID: <20170307131156.GB5500@ubuntu-hedt> (sfid-20170307_142041_308436_9135524C)
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

Applied, thanks.
