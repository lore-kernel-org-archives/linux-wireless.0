Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58124 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754193AbdG3RI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Jul 2017 13:08:27 -0400
Date: Sun, 30 Jul 2017 08:32:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-acpi@vger.kernel.org, devel@linuxdriverproject.org,
        sparmaintainer@unisys.com, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-efi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH v1 3/6] staging: unisys: Switch to use new generic UUID
 API
Message-ID: <20170730153224.GA31755@kroah.com> (sfid-20170730_190856_769797_4009E75C)
References: <20170719182857.73693-1-andriy.shevchenko@linux.intel.com>
 <20170719182857.73693-4-andriy.shevchenko@linux.intel.com>
 <1501063301.29303.247.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1501063301.29303.247.camel@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 26, 2017 at 01:01:41PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-07-19 at 21:28 +0300, Andy Shevchenko wrote:
> > There are new types and helpers that are supposed to be used in new
> > code.
> > 
> > As a preparation to get rid of legacy types and API functions do
> > the conversion here.
> > 
> > While here, re-indent couple of lines to increase readability.
> 
> This looks like no user space UUID API is involved, can be routed via
> either tree (uuid or staging).
> 
> Anyone to comment?

Doesn't apply to the staging tree at all :(
