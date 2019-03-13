Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCDAC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 01:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 473532063F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 01:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfCMBDb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 21:03:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:2897 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfCMBDa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 21:03:30 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2019 18:03:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,472,1544515200"; 
   d="scan'208";a="122168191"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga007.jf.intel.com with ESMTP; 12 Mar 2019 18:03:29 -0700
Date:   Tue, 12 Mar 2019 17:56:23 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 07/18] x86/split_lock: Enumerate #AC for split lock by
 MSR IA32_CORE_CAPABILITY
Message-ID: <20190313005623.GC31710@romley-ivt3.sc.intel.com>
References: <1552431636-31511-1-git-send-email-fenghua.yu@intel.com>
 <1552431636-31511-8-git-send-email-fenghua.yu@intel.com>
 <d0377d62-38b5-ee69-8fa2-45d3f284a182@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0377d62-38b5-ee69-8fa2-45d3f284a182@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 12, 2019 at 04:52:37PM -0700, Dave Hansen wrote:
> On 3/12/19 4:00 PM, Fenghua Yu wrote:
> > +/**
> > + * set_cpu_core_cap_bits - enumerate features supported in IA32_CORE_CAPABILITY
> > + * @c: pointer to cpuinfo_x86
> > + *
> > + * Return: void
> > + */
> > +void __init cpu_set_core_cap_bits(struct cpuinfo_x86 *c)
> 
> I think this is kerneldoc overkill.  It just wastes space and adds no
> value here.

OK. I will not add the function in kerneldoc.

Thanks.

-Fenghua
