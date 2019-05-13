Return-Path: <SRS0=GdFy=TN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C48C04AA7
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 12:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADCA9208C2
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 12:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbfEMMtU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 May 2019 08:49:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:59927 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729558AbfEMMtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 May 2019 08:49:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 05:49:18 -0700
X-ExtLoop1: 1
Received: from ozhuraki-desk.fi.intel.com (HELO [10.237.67.35]) ([10.237.67.35])
  by orsmga004.jf.intel.com with ESMTP; 13 May 2019 05:49:18 -0700
Subject: Re: [PATCH v2 00/12] NFC: nxp-nci: clean up and support new ID
To:     sedat.dilek@gmail.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     =?UTF-8?Q?Cl=c3=a9ment_Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        linux-nfc@lists.01.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org
References: <20190513104358.59716-1-andriy.shevchenko@linux.intel.com>
 <CA+icZUUu6NmQoKS-2x32Fz388Q_ahXyYzLLf5JNm=mZR+r-0kQ@mail.gmail.com>
 <CA+icZUWgQQ-h+e=fvb+yheZRm5NuL=YGMmVSjEnAizKPtMqhvg@mail.gmail.com>
From:   Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>
Message-ID: <8bb89fd4-6290-bd8f-1bdf-8e22b1beeb84@intel.com>
Date:   Mon, 13 May 2019 15:49:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CA+icZUWgQQ-h+e=fvb+yheZRm5NuL=YGMmVSjEnAizKPtMqhvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 5/13/19 2:46 PM, Sedat Dilek wrote:

> That "tag1" was my YubiKey after putting it on the NFC sticker on my ThinkPad T470.

:)

Sedat, Andy, thanks a lot and great job!

Regards,
Oleg
