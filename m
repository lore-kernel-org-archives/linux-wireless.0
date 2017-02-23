Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:60844 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751084AbdBWG0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 01:26:46 -0500
Message-ID: <1487831066.14159.17.camel@perches.com> (sfid-20170223_072653_488962_F8E9D9E5)
Subject: Re: [PATCH v2] staging: wilc1000: renames struct tstrRSSI and its
 members u8Index, u8Full
From: Joe Perches <joe@perches.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Tahia Khan <tahia.khan@gmail.com>,
        outreachy-kernel@googlegroups.com, aditya.shankar@microchip.com,
        ganesh.krishna@microchip.com, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 22 Feb 2017 22:24:26 -0800
In-Reply-To: <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com>
References: <20170222171403.GA20626@coolbox>
         <838d3e67-646d-b2d3-ef7d-5812675db6db@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-22 at 20:50 +0100, Arend Van Spriel wrote:
> On 22-2-2017 18:14, Tahia Khan wrote:
> > Fixes multiple camel case checks on struct tstrRSSI from checkpatch.pl:
[]
> Just a generic remark that may help you with other changes you will be
> making in the linux kernel. Warnings from checkpatch.pl and other tools
> are useful, but try to look further than just fixing a warning.
> Understand what the code is doing is just as important.

I'd assert understanding what the code is doing is
_more_ important.  Style consistency simply helps
improve the speed of a new reader's understanding.
