Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:40667 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbZAWTzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:55:36 -0500
Received: by fk-out-0910.google.com with SMTP id f33so1389946fkf.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 11:55:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1232738937.24871.6.camel@rc-desk>
References: <1232564283-18008-1-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-2-git-send-email-reinette.chatre@intel.com>
	 <1232564283-18008-3-git-send-email-reinette.chatre@intel.com>
	 <20090123190138.GC30486@tuxdriver.com>
	 <1232738937.24871.6.camel@rc-desk>
Date: Fri, 23 Jan 2009 21:55:34 +0200
Message-ID: <1ba2fa240901231155q79607779t1b91880b98db0839@mail.gmail.com> (sfid-20090123_205540_503449_E2290908)
Subject: Re: [ipw3945-devel] [PATCH 2/2 v2.6.29] iwlagn: fix agn rate scaling
From: Tomas Winkler <tomasw@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 9:28 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> On Fri, 2009-01-23 at 11:01 -0800, John W. Linville wrote:
>> On Wed, Jan 21, 2009 at 10:58:03AM -0800, Reinette Chatre wrote:
>> > From: Abbas, Mohamed <mohamed.abbas@intel.com>
>> >
>> > Sometime Tx reply rate different than what rate scale expecting
>> > causing rate scale to bail out. This could cause failing to
>> > commit LQ cmd. This patch will try to solve this instead of just
>> > bail out. It also make sure we start with a valid rate.
>> >
>> > Signed-off-by: mohamed abbas <mohamed.abbas@intel.com>
>> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>>
>> While I'm sure this would be nice to fix, I don't see the regression,
>> Oops or crash?
>
> You are right - this does not fix an oops or a crash. Having this patch
> in 2.6.29 is thus not critical.

What is funny that we have to wait till  2.6.30 is open to get it to
stable of 2.6.27 and 28.

Tomas
