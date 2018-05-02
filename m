Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48312 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbeEBSAD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 14:00:03 -0400
Message-ID: <1525283968.21176.633.camel@linux.intel.com> (sfid-20180502_200020_621633_29786FA2)
Subject: Re: [PATCH] NFC: fdp: Remove __func__ parameter from dev_dbg() call
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Date: Wed, 02 May 2018 20:59:28 +0300
In-Reply-To: <1525283379-7141-1-git-send-email-amit.pundir@linaro.org>
References: <1525283379-7141-1-git-send-email-amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-02 at 23:19 +0530, Amit Pundir wrote:

> -	dev_dbg(dev, "%s\n", __func__);
> +	dev_dbg(dev, "\n");

If one enables function tracer this will be redundant completely. 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
