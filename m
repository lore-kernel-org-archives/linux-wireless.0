Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:57152 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760291Ab3DCIwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 04:52:42 -0400
Received: by mail-lb0-f175.google.com with SMTP id o10so1332576lbi.20
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2013 01:52:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301964A4B@HASMSX103.ger.corp.intel.com>
References: <5156859D.4030003@gmail.com>
	<0BA3FCBA62E2DC44AF3030971E174FB301964A4B@HASMSX103.ger.corp.intel.com>
Date: Wed, 3 Apr 2013 11:52:41 +0300
Message-ID: <CANUX_P0xamwoqSboK9J6aY4fROwpdhggKSBWJkmAU-MsMrKKOQ@mail.gmail.com> (sfid-20130403_105250_043692_CDE022CE)
Subject: Re: [Ilw] [PATCH] iwlwifi: add new pci id for 6x35 series
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Shuduo Sang <sangshuduo@gmail.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 30, 2013 at 9:40 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>> some new thinkpad laptops use intel chip with new pci id need be added lspci -
>> vnn output:
>>  Network controller [0280]: Intel Corporation Centrino Advanced-N 6235
>> [8086:088f] (rev 24)
>>  Subsystem: Intel Corporation Device [8086:5260]
>>
>
> Can you please send the exact laptop models?
> I would like to do internal inquiries before we merge this patch.

Ok - we have checked. We will pick it up. Thanks!
