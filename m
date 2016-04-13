Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36837 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965990AbcDMJpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 05:45:11 -0400
Received: by mail-pa0-f43.google.com with SMTP id er2so2118149pad.3
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2016 02:45:10 -0700 (PDT)
Subject: Re: [PATCH v3] prism54: isl_38xx: Replace 'struct timeval'
To: Johannes Berg <johannes@sipsolutions.net>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
References: <20160413060916.GA21184@localhost>
 <1460536706.3057.3.camel@sipsolutions.net>
Cc: y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <570E1521.9060602@broadcom.com> (sfid-20160413_114538_705337_631F242B)
Date: Wed, 13 Apr 2016 11:45:05 +0200
MIME-Version: 1.0
In-Reply-To: <1460536706.3057.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-4-2016 10:38, Johannes Berg wrote:
> 
>> The patch was build-tested / debugged by removing the
>> "if VERBOSE > SHOW_ERROR_MESSAGES" guards.
> 
> Stands to reason that we should just remove the (more or less) dead
> code, since I don't think anyone really ever touches this driver any
> more or will ever again ...

It does bring back memories from my Intersil/Globespan/Conexant day(s),
but not sentimental enough to touch the prism54 driver.

Gr. AvS

> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
